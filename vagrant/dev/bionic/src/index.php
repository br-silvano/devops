<?php
  echo "Testando conexão <br /> <br />";
  $servername = "192.168.0.4";
  $username = "phpuser";
  $password = "pass";

  // Create connection
  $conn = new mysqli($servername, $username, $password);

  // Check connection
  if ($conn->connetion_error) {
    die("Conexão falhou: ".$conn->connection_error);
  }
  echo "Conectado com sucesso";
?>
