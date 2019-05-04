<?php
    require_once('../include/header.php');
    

    /*
   *	Este web service recibe los datos de login de un usuario, los valida contra BDD, autoriza el acceso a un usuario, si es el caso, y crea una nueva sesión
   *
   *	Parámetros:
   *	- email 
   *    - password

   *
   *	Devuelve un JSON con {status, msg, data}
   *
   *	Lista de status:
   *	- 0         No execution
   *	- 200 	    Success
   *	- 600       Datos faltantes o incorrectos del usuario
   *    - 601       Usuaio no registrado
   *    - 604       Contraseña incorrecta
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

$email = "";
if(!isset($_GET['email']) || trim($_GET['email']) == "") {
    $json['status'] 	= 601;
    $json['msg']		= "No se recibió email";
    echo json_encode($json);
    exit;

}
else {
    $email = $_GET['email'];
}

$password = "";
if(!isset($_GET['password']) || trim($_GET['password']) == "") {
    $json['status'] 	= 601;
    $json['msg']		= "No se recibió password";
    echo json_encode($json);
    exit;

}
else {
    $password = $_GET['password'];
}

$result = $db->querySelect(
    "Se verifica si existe username $username con password $password en bd",
    " SELECT
        *  
     FROM 
        User
    WHERE
        email = '$email' AND
        password = '$password'
    "

);
//$db->printQuery();
$user =  $result->fetch_assoc();
$idUser = $user['idUser'];

if($user) {

    $json['data']['idUser'] = $idUser;

} else {
    $json['msg']            = 'Usuario o contraseña incorrectos';
    $json['status']         = 600;
    echo(json_encode($json));
    exit;

}
$newToken = md5(uniqid(rand(), true));
$result = $db->queryInsert(
    "Se inserta el registro de login",
    array("
    INSERT INTO Login(
        idUsuario,
        email,
        token,
        status
    )
    VALUES(
        $idUser,
        '$email'
        '$newToken',
        'active'
    )

    ")
);

//$db->printQuery();

if (!$result) { // No se pudo insertar login nuevo
    $json['status'] = '600';

    $json['msg']    = 'No se pudo generar login';
   
    echo(json_encode($json));
    exit;
}
$idLogin = $result;

$json['status']                 = '200';
$json['msg']                    = 'Datos correctos';
$json['data']['token']          = $newToken;
$json['data']['idUser']         = $idUser;
$json['data']['public_key']     = $user['public_key'];
$json['data']['name']           = $user['name'];
$json['data']['email']          = $user['email'];





echo(json_encode($json));
    
?>