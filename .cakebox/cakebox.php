#!/usr/bin/php -q
<?php
require_once __DIR__.'/vendor/autoload.php';
main();

/**
 * Main function using class above
 */
function main(){

    try {
        $cakebox = new Cakebox;         // should parse commandline options, etc.
    }
    catch (Exception $e) {
        echo $e->getMessage() ."\n";
        exit(1);
    }

    # Include required command script
    include "commands/". $cakebox->getSubcommand() . ".php";

    # testing list function
    function list($arg = null){
        echo "Hello list\n";
    }
    list();
    exit(0);
}


/**
* Cakebox class
*
*
* @return bool false when no errors occured
*/
class Cakebox
{

    /** @var array */
    public $subcommands = [
        'app',
        'site',
        'database',
        'git',
        'variable'
    ];
     /** @var string */
    private $subcommand;

    /**
     * Here the object is instantiated, it always:
     * - verifies the subcommand parameter
     */
    public function __construct() {
        $this->subCommand = $this->_findSubcommand();
        $this->_removeSubcommand();
    }

    private function _findSubcommand(){
        global $argv;
        if (empty($argv[1])){
            throw new Exception($this->getUsage() . "\nError: missing subcommand argument");
        }
        if (!in_array($argv[1], $this->subcommands)){
            throw new Exception($this->getUsage() . "\nError: unsupported subcommand argument");
        }
        $this->subcommand = $argv[1];
    }

    /**
     * Removes subcommand from $argv
     */
    private function _removeSubcommand() {
        global $argv;
        array_splice($argv, 1, 1);
    }

    public function getSubcommand(){
        return $this->subcommand;
    }


    /**
     * getUsage() returns the usage instruction for this script
     *
     * @param string $error message @todo
     * @return string $message containing the cakebox command usage instruction.
     */
    public function getUsage(){
        $message =  "Usage: cakebox <subcommand> [<args>]\n";
        $message .= "Subcommands:\n";
        foreach ($this->subcommands as $subcommand){
            $message .= "  $subcommand\n";
        }
        $message .= "For help on any individual subcommands run `cakebox <subcommand> --help`\n";
        return ($message);
    }


    /**
     * dirAvailable() is used to check if a directory is non-existent or empty.
     *
     * @param string $directory
     * @return boolean true is the directory is available
     */
     public function dirAvailable($directory){
         if (!file_exists($directory)){
             return true;
         }
         if (($files = @scandir($directory)) && count($files) <= 2) {
             return true;
         }
         return false;
     }

    /**
     * runShell() is used to execute bash commands (e.g. for git clone).
     *
     * @todo harden error-handling + supress stdout (try$err ?)
     * @param string $command
     * @param boolean $username (username to execute as, e.g. vagrant)
     * @return array $ret, $out, $err
     */
     public function executeShell($command, $username=null){
         if (!$username){
            $ret = exec("$command", $out, $err);
         }else{
            echo "SU AS $username\n";
            $ret = exec("su $username -c \"$command\"", $out, $err);
         }
        #var_dump($ret);
        #var_dump($out);
        #var_dump($err);
     }

}
