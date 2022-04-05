<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Sign-up Client</title>
    </head>
    <body>

        <h1>Sign-up Cliente</h1>

        <form action = "registrazione.jsp" method="POST">
            <select name = "tipo" id="tipo">
                <option value = "cliente">Cliente</option>
                <option value = "prop">Proprietario</option>
            </select>
            <input type="submit" value="Seleziona"/> 
        </form>

        <% 
            String tipo = null;
            tipo = request.getParameter("tipo");
        %>

        <a href = "index.html"> 
            <input type="button" value="Indietro"/> <br> 
        </a>

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
            
            if(tipo.equals("cliente")){

                out.println("<form action = 'registrazione.jsp' method='POST'>");
                    out.println("Nome: <input type = 'text' id = 'nome' name = 'nome' placeholder = 'nome' required>");
                    out.println("Cognome: <input type = 'text' id = 'cognome' name = 'cognome' placeholder = 'cognome' required>");
                    out.println("Telefono: <input type = 'text' id = 'telefono' name = 'telefono' placeholder = 'telefono' required>");
                    out.println("<br> <br>");
                    out.println(" Username: <input type= 'text' id= 'username' name= 'username' placeholder= 'username' required>");
                    out.println("Mail:<input type = 'text' id = 'mail' name = 'mail' placeholder = 'mail' required>");
                    out.println("Password: <input type= 'password' id= 'password' name= 'password' placeholder= 'password' required>");
                    
                    out.println("<input type='submit' id='btn' name='btn' value='Sign-up'>");
                out.println("</form>");


                nome = request.getParameter("nome");
                cognome = request.getParameter("cognome");
                telefono = request.getParameter("telefono");
                username = request.getParameter("username");
                mail = request.getParameter("mail");
                password = request.getParameter("password");

                System.out.println("NOME "+nome);
                
                connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "Parrucchiere.accdb");
                
                Statement st = connection.createStatement();

                String queryVerifica = "SELECT * FROM Utente WHERE usr = '"+username+"';";   
                String queryInserisciUtente = "INSERT INTO Utente (usr,psw) VALUES ('"+username+"', '"+password+"')";    

                ResultSet result = st.executeQuery(queryVerifica);


                if((username != null) || (password != null)){

                    if(result.next()){
                        out.println("<p>Questo account è già esistente</p>");
                    }else{
                        st.executeUpdate(queryInserisciUtente);

                        String queryID = "SELECT ID FROM Utente WHERE usr = '"+username+"'";
                        ResultSet r = st.executeQuery(queryID);
                        r.next();
                        String IDUtente = r.getString("ID");
                        System.out.println("ID"+IDUtente);
                        String queryInserisciCliente = "INSERT INTO Cliente (IDUtente, nome,cognome,telefono, username, email, password ) VALUES ('"+IDUtente+"','"+nome+"', '"+cognome+"', '"+telefono+"', '"+username+"' , '"+mail+"' , '"+password+"')";
                        st.executeUpdate(queryInserisciCliente);
                        response.sendRedirect("index.html"); 
                    }
                }
                
            }else if(tipo.equals("prop")){
                out.println("<form action= 'registrazione.jsp' method='POST'>");
                    out.println("Nome Locale: <input type = 'text' id = 'nomeLocale' name = 'nomeLocale' placeholder = 'Nome Locale' required>");
                    out.println("Via: <input type= 'text' id= 'via' name= 'via' placeholder= 'via'>");
                    out.println("Numero Civico: <input type= 'text' id= 'nCivico' name= 'nCivico' placeholder= 'Numero Civico' required>");
                    out.println("Citta': <input type= 'text' id= 'citta' name= 'citta' placeholder= 'Citta'>");
                    out.println("Telefono: <input type= 'text' id= 'telefono' name= 'telefono' placeholder= 'Telefono' required>");
                    out.println("<br> <br>");
                    out.println("Username: <input type= 'text' id= 'username' name= 'username' placeholder= 'username' required>");
                    out.println("Email: <input type = 'text' id = 'mail' name = 'mail' placeholder = 'mail' required>");
                    out.println("Password: <input type= 'password' id= 'password' name= 'password' placeholder= 'password' required>");
                
                    out.println("<input type='submit' id='btn' name='btn' value='Sign-up'>");
                out.println("</form>");

                
                connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
                
                Statement st = connection.createStatement();

            }
        }catch(Exception e){
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