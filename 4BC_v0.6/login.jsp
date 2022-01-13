<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Sign-in</title>
    </head>
    <body>
        <h1>Sign-in</h1>
        <form action="login.jsp" method="POST">
            <input type="text" id="username" name="username" placeholder="username">
            <input type="password" id="password" name="password" placeholder="password">
            <input type="submit" id="btn" name="btn" value="Accedi">
        </form>

        <a href = "index.html"> 
            <input type="button" value="Indietro"/> <br> 
        </a>
        
        <%

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

            username = request.getParameter("username");
            password = request.getParameter("password");
            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
            String query = "SELECT username FROM Clienti WHERE username = '"+username+"'AND password = '"+password+"';"; 
            String query2 = "SELECT username FROM Proprietari WHERE username = '"+username+"'AND password = '"+password+"';"; 


            HttpSession s = request.getSession();
            String dataValue = username;

            Statement st = connection.createStatement();
            ResultSet r1 = st.executeQuery(query);
            ResultSet r2 = st.executeQuery(query2);
            
            if(r1.next()){    
                s.setAttribute("username", dataValue);  
                response.sendRedirect("loginCliente.jsp"); 
            }else if(r2.next()){
                s.setAttribute("username", dataValue); 
                response.sendRedirect("loginOwner.jsp");
            }
            else{
                if((username != null) && (password != null)){
                    out.println("<p>Credenziali errate</p>");
                }              
            }
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