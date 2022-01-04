<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Sign-in Client</title>
    </head>
    <body>
        <h1>Sign-in Cliente</h1>
        <form action="login_C.jsp" method="POST">
            <input type="text" id="username" name="username" placeholder="username">
            <input type="password" id="password" name="password" placeholder="password">
            <input type="submit" id="btn" name="btn" value="Accedi">
        </form>

        <a href = "index.html"> 
            <input type="button" value="Indietro"/> <br> 
        </a>
        
        <%

        HttpSession s; //non sono sicuro

        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        
        String username=null;
        String password=null;
        Connection connection=null;

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{
            username=request.getParameter("username");
            password=request.getParameter("password");
            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
            String query = "SELECT username FROM Clienti WHERE username = '"+username+"'AND password = '"+password+"';"; 
            
            Statement st = connection.createStatement();
            ResultSet result = st.executeQuery(query);
            
            if(result.next()){         
                response.sendRedirect("loginCliente.html"); 
            }
            else{
                if((username != null) && (password != null)){
                    out.println("<p>Credenziali errate</p>");
                }              
            }

            //s.setAttribute("nome_attributo","valore");
        }
        catch(Exception e){
            out.println(e);
        }

        

        finally{
            if(connection != null){
                try{
                    connection.close();
                }
                catch(Exception e){out.println("Errore nella chiusura della connessione");}
            }
        }
        %>
    </body>
</html>