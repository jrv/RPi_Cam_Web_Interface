<!DOCTYPE html>
<html>
  <head>
    <title>RPi Cam Download</title>
  </head>
  <body>
    <p><a href="index.html">Back</a></p>
    <?php
      if(isset($_GET["file"])) {
        echo "<h1>Preview</h1>";
        if(substr($_GET["file"], -3) == "jpg") echo "<img src='media/" . $_GET["file"] . "' width='480' height='360'>";
        else echo "<video width='640' height='360' controls><source src='media/" . $_GET["file"] . "' type='video/mp4'>Your browser does not support the video tag.</video>";
        echo "<p><input type='button' value='Download' onclick='window.open(\"download.php?file=" . $_GET["file"] . "\", \"_blank\");'> ";
      }
    ?>
    <h1>Files</h1>
    <?php
      $files = scandir("media");
      if(count($files) == 2) echo "<p>No videos/images saved</p>";
      else {
        foreach($files as $file) {
          if(($file != '.') && ($file != '..')) {
            $fsz = round ((filesize("media/" . $file)) / (1024 * 1024));
            echo "<p><a href='preview.php?file=$file'>$file</a> ($fsz MB)</p>";
          }
        }
      }
    ?>
  </body>
</html>
