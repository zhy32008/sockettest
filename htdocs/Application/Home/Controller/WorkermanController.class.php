<?php
/**
 * Created by PhpStorm.
 * User: dennis.zhao
 * Date: 16/9/1
 * Time: 下午2:29
 */

namespace Home\Controller;

use Workerman\Worker;

class WorkermanController
{

    public function index(){

        if (!IS_CLI){

            die("access illegal");
        }

       define('MAX_REQUEST',1000);

        Worker::$daemonize = true;//以守护进程运行
        Worker::$pidFile = '/data/';
    }
}