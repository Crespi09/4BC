<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Sign-up Client</title>
    </head>
    <body>

        <h1>Sign-up Cliente</h1>

        <%
        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        
        String nome = null;
        String cognome = null;
        String telefono = null;
        String username=null;
        String mail = null;
        String password=null;
        
        Connection connection=null;

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{
            
            nome = request.getParameter("nome");
            cognome = request.getParameter("cognome");
            telefono = request.getParameter("telefono");
            username = request.getParameter("username");
            mail = request.getParameter("mail");
            password = request.getParameter("password");
            
            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
            
            Statement st = connection.createStatement();

            String query2 = "SELECT * FROM Clienti WHERE email = '"+mail+"';";           
            String query = "INSERT INTO Clienti (nome,cognome,telefono, username, email, password ) VALUES ('"+nome+"', '"+cognome+"', '"+telefono+"', '"+username+"' , '"+mail+"' , '"+password+"')";

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