<?php
/**
 * Created by PhpStorm.
 * User: Manish
 * Date: 11/1/2016
 * Time: 6:55 PM
 */
//require_once 'dbDetails.php';

//connecting to the db
$con = mysqli_connect('localhost','root','Noki8110a','test') or die("Unable to connect");

//sql query
$sql = "SELECT * FROM `PdfTable`";

//getting result on execution the sql query
$result = mysqli_query($con,$sql);

//response array
$response = array();

$response['error'] = false;

$response['message'] = "PDfs fetched successfully.";

$response['pdfs'] = array();

//traversing through all the rows

while($row =mysqli_fetch_array($result)){
    $temp = array();
    $temp['id'] = $row['id'];
    $temp['url'] = $row['PdfURL'];
    $temp['name'] = $row['PdfName'];
    array_push($response['pdfs'],$temp);
}

echo json_encode($response);