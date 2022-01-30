<!DOCTYPE html>

<html>
    <head>
        <title>Login Owner</title>
    </head>

    <body>
        <h1>Login owner avvenuto con successo</h1>

        <%
            String usr = (String) request.getSession().getAttribute("username");
            String id = (String) request.getSession().getAttribute("id");
            if((usr == null) || (id == null)){
                 response.sendRedirect("index.html");
            }
            out.println("<h2>Benvenuto "+tmp+"</h2>");
            out.println("<p>Opzioni: </p>");
        %>

        <a href = "orariOwner.jsp"> 
            <input type="button" value="Configura Orario"/> <br> 
        </a>

        <a href = "sell.jsp"> 
            <input type="button" value="Prodotti in vendita"/> <br> 
        </a>

        <a href = "accept.jsp"> 
            <input type="button" value="Prenotazioni"/> <br> 
        </a>
        <br>
        <a href = "index.html"> 
            <input type="button" value="Home"/> <br> 
        </a>


    </body>
</html>