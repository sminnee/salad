<?php
	$param = (isset($_POST['mode'])) ? $_POST['mode'] : '';
	switch($param) {
		default:
		case "shortdelay":
			break;
		case "longdelay":
			sleep(2);
			break;
		case "noreturn":
			return;
	}
?>
This was retrieved via AJAX.
