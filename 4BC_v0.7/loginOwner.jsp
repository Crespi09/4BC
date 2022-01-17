<!DOCTYPE html>

<html>
    <head>
        <title>Login Owner</title>
    </head>

    <body>
        <h1>Login owner avvenuto con successo</h1>

        <%
            String tmp = (String) request.getSession().getAttribute("username");
            out.println("<h2>Benvenuto "+tmp+"</h2>");
            out.println("<p>Opzioni: </p>");
        %>
        <a href = "sell.jsp"> 
            <input type="button" value="Prodotti in vendita"/> <br> 
        </a>

        <a href = "accept.html"> 
            <input type="button" value="Prenotazioni"/> <br> 
        </a>
        <br>
        <a href = "index.html"> 
            <input type="button" value="Home"/> <br> 
        </a>


    </body>
</html>