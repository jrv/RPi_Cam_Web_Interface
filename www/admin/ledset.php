<?php
#ledset.php?led=" + led + "&val=" + led.checked);
$led = $_GET['led'];
$val = $_GET['val'];
if ($val == "true") { $val1 = 1; } else { $val1 = 0; }
$cmd1 = "/usr/local/bin/gpio mode $led out";
#error_log($cmd1);
exec($cmd1);
$cmd2 = "/usr/local/bin/gpio write $led $val1";
exec($cmd2);
#error_log($cmd2);
?>
