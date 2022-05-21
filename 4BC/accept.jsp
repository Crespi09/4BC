<!DOCTYPE html>
<html>
    <head>
        <title>Accept</title>
    </head>
    
    <body>
        <h1>Accettazione</h1>
        <p>Visualizzazione delle richieste del cliente e possibilita' di accettarle e/o rifiutarle</p>

        <a href = "loginOwner.jsp"> 
            <input type="button" value="Home"/> <br> 
        </a>

        <%
            String usr = (String) request.getSession().getAttribute("username");
            if(usr == null){
                response.sendRedirect("index.html");
            }
        %>
    </body>

</html>