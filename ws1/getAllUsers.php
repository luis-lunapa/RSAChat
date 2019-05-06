<?php
    require_once('../include/header.php');
    

    /*
   *	Este web service regresa los datos de login
   *
   *	Parámetros: 
   *    - token

   *
   *	Devuelve un JSON con {status, msg, data}
   *
   *	Lista de status:
   *	- 0         No execution
   *	- 200 	    Success
   *	- 600       Datos faltantes o incorrectos del usuario
   *    - 601       No se recibio idUsuario
   *    - 604       Token no recibido o válido
   */

header('Content-Type: application/json');
$json = array (
    'status'    => '0',
    'msg'       => 'Sin Ejecución',
    'data'      => array()
);

if(isset($_GET['debug'])){
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
}


$token = "";
if(!isset($_GET['token']) || trim($_GET['token']) == "") {
    $json['status'] 	= 602;
    $json['msg']		= "No se recibió token con autorización";
    echo json_encode($json);
    exit;

}
else {
    $token = $_GET['token'];
}

$idUser = "";
if(!isset($_GET['idUser']) || trim($_GET['idUser']) == "") {
    $json['status'] 	= 602;
    $json['msg']		= "No se recibió idUser ";
    echo json_encode($json);
    exit;

}
else {
    $idUser = $_GET['idUser'];
}


$valid = $db->querySelect(
    "Se verifica que el token recibido es válido",
    "SELECT
       *
    FROM
        Login l 
        
    WHERE
        token = '$token' AND
        status = 'active'
    "
);

$isValid = $valid->fetch_assoc();

if (!isset($isValid)) {
    $json['status'] = '605';
    $json['msg']    = 'No tiene permiso de realizar esta petición';
    echo(json_encode($json));
    exit;

}


$result = $db->querySelect(
    "Se obtienen todos datos de usuarios",
    "SELECT
        u.name,
        u.email,
        u.public_key
    FROM
       User u 
    WHERE 
        u.idUser != $idUser

    "
);



if(!isset($result)) {
    $json['status'] = '605';
    $json['msg']    = 'No se obtuvieron usuarios :O';
    echo(json_encode($json));
    exit;

}

$usuarios = array();

while($row = $result->fetch_assoc()) {
array_push($usuarios, array(

'name' => $row['name'],
'email' => $row['email'],
'public_key' => $row['public_key']

)
);



}




$json['status']                 = '200';
$json['msg']                    = 'Datos obtenidos correctamente';
$json['data'] = $usuarios;

echo(json_encode($json));
    
?>