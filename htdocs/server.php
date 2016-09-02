<?php
/**
 * Created by PhpStorm.
 * User: dennis.zhao
 * Date: 16/9/2
 * Time: 下午4:54
 */

$address = "127.0.0.1";
$port = 2046;
$sock = socket_create(AF_INET,SOCK_STREAM,SOL_TCP) or die('socket_create() 失败的原因是:'.socket_strerror(socket_last_error()).'\n');
socket_set_block($sock) or die("socket_set_block() 失败的原因是:" . socket_strerror(socket_last_error());
$result = socket_bind($sock,$address,$port) or die("socket_bind() 失败的原因是:" . socket_strerror(socket_last_error()) . "/n");

$result = socket_listen($sock,4) or die("socket_listen() 失败的原因是:" . socket_strerror(socket_last_error()) . "/n");



