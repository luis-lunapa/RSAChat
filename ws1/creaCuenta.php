<?php
    require_once('../include/header.php');
    

    /*
   *	Este web service registra un nuevo usuario
   *
   *	Parámetros:
   *	- name
   *    - email
   *    - publicKey
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

$name = "";
if(!isset($_GET['name']) || trim($_GET['name']) == "") {
    $json['status'] 	= 601;
    $json['msg']		= "No se recibió username";
    echo json_encode($json);
    exit;

}
else {
    $name = $_GET['name'];
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

$public_key = "";
if(!isset($_GET['public_key']) || trim($_GET['public_key']) == "") {
    $json['status'] 	= 601;
    $json['msg']		= "No se recibió public_key";
    echo json_encode($json);
    exit;

}
else {
    $public_key = $_GET['public_key'];
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
    "Se verifica si ya existe un email $username en bd",
    " SELECT
        *  
     FROM 
        User
    WHERE
        email = '$email'
    "

);


if($user) {

    $json['msg']            = 'Ya existe un usuario con este email';
    $json['status']         = 600;
    echo(json_encode($json));
    exit;
}

$result = $db->queryInsert(
    "Se registra nuevo usuario",
    array("
    INSERT INTO User(
        name,
        email,
        password,
        public_key
    )
    VALUES(
        '$name',
        '$email',
        '$password',
        '$public_key'
    )

    ")
);


// $newToken = md5(uniqid(rand(), true));
// $result = $db->queryInsert(
//     "Se inserta el registro de login",
//     array("
//     INSERT INTO Login(
//         idUsuario,
//         token,
//         status
//     )
//     VALUES(
//         $idUser,
//         '$newToken',
//         'active'
//     )

//     ")
// );

//$db->printQuery();

if (!$result) { // No se pudo insertar login nuevo
    $json['status'] = '600';

    $json['msg']    = 'No se pudo registrar usuario';
   
    echo(json_encode($json));
    exit;
}

$json['status']              = '200';
$json['msg']                 = 'Usuario creado correctamente';



echo(json_encode($json));
    
?>