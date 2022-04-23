<!DOCTYPE html>

<html>
    <head>
        <title>Sign-in Cliente</title>
    </head>

    <body>
        <h1>Login cliente avvenuto con successo</h1>

        <%
            String usr = (String) request.getSession().getAttribute("username");
            String id = (String) request.getSession().getAttribute("id");
            
            if((usr == null) || (id == null)){
                 response.sendRedirect("index.html");
            }
            out.println("<h2>Benvenuto "+usr+"</h2>");
            out.println("<p>Opzioni: </p>");
        %>

        <a href = "booking.jsp"> 
            <input type="button" value="Booking"/> <br> 
        </a>

        <a href = "buy.jsp"> 
            <input type="button" value="Buy Products"/> <br> 
        </a>
        <br>


        <%
             out.println("<form action = 'loginCliente.jsp' method='POST'>");  
                out.println("<input type='hidden' id='controlloLogOut' name='controlloLogOut' value = 'y'>");
                out.println("<td> <input type= 'submit' class = 'btn2' value= 'Log-Out'></td>");
            out.println("</form>");

            String controlloLogOut = (String) request.getParameter("controlloLogOut");
            if(controlloLogOut != null && (controlloLogOut).equals("y")){
                session.invalidate();
                response.sendRedirect("index.html");
            }
        %>  

        <br><a href = "index.html"> 
            <input type="button" value="Home"/> <br> 
        </a>  

    </body>
</html>