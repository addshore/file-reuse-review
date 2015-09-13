<?php
	echo "<html><head></head><body>";
	$message = shell_exec( __DIR__ . '/run.sh' );
	if( $message === null ) {
		echo "<p>Something went wrong!</p>";
	} else {
		echo "<p>All updated!</p>";
	}
	echo "</body></html>";

	echo file_get_contents( __DIR__ . '/index.html' );
