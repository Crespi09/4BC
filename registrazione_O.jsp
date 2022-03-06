<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Sign-up Owner</title>
    </head>
    <body>

        <h1>Sign-up Owner</h1>

        <form action= "registrazione_O.jsp" method="POST">
            Nome Locale: <input type = "text" id = "nomeLocale" name = "nomeLocale" placeholder = "Nome Locale" required>
            Via: <input type= "text" id= "via" name= "via" placeholder= "via">
            Numero Civico: <input type= "text" id= "nCivico" name= "nCivico" placeholder= "Numero Civico" required>
            Citta': <input type= "text" id= "citta" name= "citta" placeholder= "Citta'"> 
            Telefono: <input type= "text" id= "telefono" name= "telefono" placeholder= "Telefono" required> 
            <br> <br>
            Username: <input type= "text" id= "username" name= "username" placeholder= "username" required>
            Email: <input type = "text" id = "mail" name = "mail" placeholder = "mail" required>
            Password: <input type= "password" id= "password" name= "password" placeholder= "password" required>
            
            <input type="submit" id="btn" name="btn" value="Sign-up">
        </form>

        <a href = "index.html"> 
            <input type="button" value="Indietro"/> <br> 
        </a>

        <%
        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        
        String nomeLocale = null;
        String via = null;
        String nCivico = null;
        String citta = null;
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
            
            nomeLocale = request.getParameter("nomeLocale");
            via = request.getParameter("via");
            nCivico = request.getParameter("nCivico");
            citta = request.getParameter("citta");
            telefono = request.getParameter("telefono");
            username = request.getParameter("username");
            mail = request.getParameter("mail");
            password = request.getParameter("password");
            
            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
            
            Statement st = connection.createStatement();

            String query2 = "SELECT * FROM Proprietari WHERE email = '"+mail+"';";           
            String query = "INSERT INTO Proprietari (nomeLocale,via,nCivico,citta,telefono,username,email,password) VALUES ('"+nomeLocale+"', '"+via+"', '"+nCivico+"' , '"+citta+"', '"+telefono+"' , '"+username+"' , '"+mail+"' , '"+password+"')";

            ResultSet result = st.executeQuery(query2);

            if((username != null) || (password != null) || (mail != null)){
                if(result.next()){
                    out.println("<p>Questo account è già esistente</p>");
                }else{
                    st.executeUpdate(query);
                    response.sendRedirect("index.html"); 
                }
            }else{
                out.println("Inserisci i valori nei campi");
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