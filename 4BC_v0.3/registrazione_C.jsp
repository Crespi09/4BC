<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Sign-up Client</title>
    </head>
    <body>

        <h1>Sign-up Cliente</h1>
        <form action= "registrazione_C.jsp" method="POST">
            <input type = "text" id = "nome" name = "nome" placeholder = "nome">
            <input type = "text" id = "cognome" name = "cognome" placeholder = "cognome">
            <input type= "text" id= "username" name= "username" placeholder= "username">
            <input type= "password" id= "password" name= "password" placeholder= "password">
            <input type = "text" id = "mail" name = "mail" placeholder = "mail">
            <input type="submit" id="btn" name="btn" value="Sign-up">
        </form>

        <%
        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        
        String username=null;
        String password=null;
        String mail = null;
        String nome = null;
        String cognome = null;
        
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
            mail = request.getParameter("mail");
            nome = request.getParameter("nome");
            cognome =request.getParameter("cognome");
            
            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
            
            Statement st = connection.createStatement();

            String query2 = "SELECT * FROM Clienti WHERE email = '"+mail+"';";           
            String query = "INSERT INTO Clienti (username, password, email, nome, cognome) VALUES ('"+username+"', '"+password+"', '"+mail+"', '"+nome+"' , '"+cognome+"')";

            ResultSet result = st.executeQuery(query2);

            if(result.next()){
                out.println("<p>Questo account è già esistente</p>");
            }else{
                st.executeUpdate(query);
                response.sendRedirect("login_C.jsp"); 
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