<?
class DBManager {
    ///==================================================
    /// Parametros de conexión con base de datos
    ///==================================================
    
    private $user = "u111876580_rsach"; // Usuario de bd
    private $password = "RSA@12345"; // Password bd
    private $db = "u111876580_rsach"; // Nombre db
    private $host = "localhost"; // Host db

    ///==============================================
    /// Variables de control interacción con BD
    ///==============================================

    private $queryTotal = 0; // Numero de queries ejecutadas en esta session

    private $quey = "";
    private $comment = "";


    private $conn; //Conexion con db

    public function DBManager() {
        if (!isset($this->conn)) {
            $this->conn = mysqli_connect($this->host, $this->user, $this->password, $this->db);
            if ($this->conn->connect_error) {
                die('Conexión con base de datos falló: ' . $this->conn->connect_error);
            }

        }
    }

    /*

    Esta funcion obtiene de un registro varios campos

    */

    public function querySelect($comment = "", $query = "") {

        if ($comment == "") {

            echo "Query sin comentario.";
            return;
        }

        if ($query == "") {
            echo "Query vacia";
            return;
        }

        $this->queryTotal += 1;

        $this->query = $query;
        $this->comment = $comment;

        $result = $this->conn->query($query);

        return $result;

    }



    /*

    Esta funcion hace un insert a la bd con transaccion

    */
    public function queryInsert($comment = "", $query = array()) {

        if ($comment == "") {

            echo "Query sin comentario.";
            return;
        }

        if (sizeof($query) == 0 ) {
            echo "Query vacia";
            return;
        }

       
        $this->queryTotal += 1;

        $this->conn->query("START TRANSACTION");

        foreach ($query as $q) {
            $this->query = $q;

            if (!$this->conn->query($q)) {
            

                $errorMsg = "Error al ejecutar query $q". mysqli_error($this->conn);
                echo $errorMsg;
                $this->conn->query("ROLLBACK");

                return 0;
            }

            $id = $this->conn->insert_id;

            $this->conn->query("COMMIT");
            return $id;

        }





    }


   

    
    public function printQuery() {
        echo($this->query);
    }





}



?>