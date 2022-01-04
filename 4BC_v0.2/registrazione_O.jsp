<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Sign-up Owner</title>
    </head>
    <body>
        <%
        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        

        String username=null;
        String password=null;
        String mail = null;
        String nome = null;
        String cognome = null;
        String nomeLocale= null;
        String via = null;
        String nCivico = null;
        String citta = null;
        
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
            nomeLocale = request.getParameter("nomeLocale");
            via = request.getParameter("via");
            nCivico = request.getParameter("nCivico");
            citta = request.getParameter("citta");  
            
            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
            
            Statement st = connection.createStatement();

            String query2 = "SELECT * FROM Proprietari WHERE email = '"+mail+"';";           
            String query = "INSERT INTO Proprietari (username, password, email, nomeLocale, via, nCivico, Città) VALUES ('"+username+"', '"+password+"', '"+mail+"', '"+nome+"' , '"+cognome+"', '"+nomeLocale+"' , '"+via+"' , '"+nCivico+"', '"+citta+"';)";

            ResultSet result = st.executeQuery(query2);

            if(result.next()){
                out.println("<p>Questo account è già esistente</p>");
            }else{
                st.executeUpdate(query);
                response.sendRedirect("login_O.jsp"); 
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