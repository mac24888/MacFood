

<?php

header("content-type:text/javascript;charset=utf-8");
error_reporting(0);
error_reporting(E_ERROR | E_PARSE);

if(isset($_GET['send_notification'])){
   send_notification ();
}

function send_notification()
{
	echo 'Hello';
define( 'API_ACCESS_KEY', 'AAAA1M9AEn4:APA91bHXMejaOBCEE7P4PHfKdl7QPG8qQjP3aOBRFhB-n4X1ggjCaFAFxhu-HSD8_El3tmnCDmWqIWKsNjlreY6Z7s3Rd1f2UdDjCUs727utRIp6EMZUzCLLaZBzimegESF2BAucPlmF');
 //   $registrationIds = ;
#prep the bundle
     $msg = array
          (
		'body' 	=> $_REQUEST['body'],
		'title'	=> $_REQUEST['title'],
		'click_action' => 'FLUTTER_NOTIFICATION_CLICK',
		'sound' => 'default',
		'content_available' => 'true',
		'priority' => 'high', 	
          );

      $data = array
          (
		'body' 	=> $_REQUEST['body'],
		'title'	=> $_REQUEST['title'],
		'click_action' => 'FLUTTER_NOTIFICATION_CLICK',
		'sound' => 'default',
		'content_available' => 'true',
		'priority' => 'high', 	
          );

	$fields = array
			(
				'to'		=> $_REQUEST['token'],
				'notification'	=> $msg,
				'data' => $data,
			);
	
	
	$headers = array
			(
				'Authorization: key=' . API_ACCESS_KEY,
				'Content-Type: application/json'
			);
#Send Reponse To FireBase Server	
		$ch = curl_init();
		curl_setopt( $ch,CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send' );
		curl_setopt( $ch,CURLOPT_POST, true );
		curl_setopt( $ch,CURLOPT_HTTPHEADER, $headers );
		curl_setopt( $ch,CURLOPT_RETURNTRANSFER, true );
		curl_setopt( $ch,CURLOPT_SSL_VERIFYPEER, false );
		curl_setopt( $ch,CURLOPT_POSTFIELDS, json_encode( $fields ) );
		$result = curl_exec($ch );
		echo $result;
		curl_close( $ch );
}
?>