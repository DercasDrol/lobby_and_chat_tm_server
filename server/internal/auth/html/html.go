package html

const (
	Success = `
		<!DOCTYPE html>
		<html>
			<head>
				<title>Basic Web Page</title>
			</head>
			<body onload="waitFiveSec()">
			<div style="margin:auto;width:50%;">
				Success login! This page will be closed after 5 seconds. 
			<script>
				function waitFiveSec(){
					setTimeout(window.close, 5000)
				}
			</script>
			</body>
		</html>
	`
)
