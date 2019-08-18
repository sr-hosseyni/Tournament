<?php
function foo($bar) {
$qux = strpos('abcdef', $bar);
if ($qux) {
$qux += 1;
} else {
$qux = -1;
}
return $qux;
}
$x = foo('abc');
$y = foo('def');


echo "x=[$x], y=[$y]";
