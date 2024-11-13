<?php
exec('mode COM4: baud=115200 data=8 stop=1 parity=n');
$fd = dio_open('COM4:', O_RDWR);

dio_write($fd, 'hello');

while (1) {
    $data = dio_read($fd, 1024);
    if ($data) {
        var_dump('Get data');
        var_dump($data);
    }
    else{
        var_dump('No data');
    }
    sleep(1);
}
dio_close($fd);
?>