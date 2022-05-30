<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Sign-up</title>
    </head>
    <body>

        <h1>Sign-up</h1>

        <form action = "registrazione.jsp" method="POST">
            <select name = "tipo" id="tipo">
                <option value = "cliente">Cliente</option>
                <option value = "prop">Proprietario</option>
            </select>
            <input type="submit" value="Seleziona"/> 
        </form>

        <%
        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        
        

        String tipo;

        String nome;
        String cognome;
        String telefono;
        String username;
        String mail;
        String password;
        
        Connection connection=null;

        connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "Parrucchiere.accdb");
                        
        Statement st = connection.createStatement();

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{
            
            tipo = request.getParameter("tipo");
            if(tipo != null){
                
                switch (tipo){
                    case "cliente":

        %>
                        <form action = "registrazione.jsp" method='POST'>
                            Nome: <input type = 'text' id = 'nome' name = 'nome' placeholder = 'nome' required/>
                            Cognome: <input type = 'text' id = 'cognome' name = 'cognome' placeholder = 'cognome' required/>
                            Telefono: <input type = 'text' id = 'telefono' name = 'telefono' placeholder = 'telefono' required/>
                            <br> <br>
                            Username: <input type= 'text' id= 'username' name= 'username' placeholder= 'username' required/>
                            Mail: <input type = 'mail' id = 'mail' name = 'mail' placeholder = 'mail' required/>
                            Password: <input type= 'password' id= 'password' name= 'password' placeholder= 'password' required/>
                            <input type='hidden'  name='tipo' value = 'cliente'>

                            <input type='submit' id='btn' name='btn' value='Sign-up'/>
                        </form>

        <%
                        nome = request.getParameter("nome");
                        cognome = request.getParameter("cognome");
                        telefono = request.getParameter("telefono");
                        username = request.getParameter("username");
                        mail = request.getParameter("mail");
                        password = request.getParameter("password");

                        System.out.println("NOME "+nome);
                        
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
                                System.out.println("ID: "+IDUtente);
                                String queryInserisciCliente = "INSERT INTO Cliente (IDUtente, nome,cognome,telefono,email) VALUES ('"+IDUtente+"','"+nome+"', '"+cognome+"', '"+telefono+"', '"+mail+"')";
                                st.executeUpdate(queryInserisciCliente);
                                response.sendRedirect("index.html"); 
                            }
                        }
                        
                        break;

                    case "prop": 

                    %>
                        
                        <form action= 'registrazione.jsp' method='POST'>
                            Nome: <input type = 'text' id = 'nome' name = 'nome' placeholder = 'nome' required>
                            Cognome: <input type = 'text' id = 'cognome' name = 'cognome' placeholder = 'cognome' required>
                            Nome Locale: <input type = 'text' id = 'nomeLocale' name = 'nomeLocale' placeholder = 'Nome Locale' required>
                            Via: <input type= 'text' id= 'via' name= 'via' placeholder= 'via'>
                            Numero Civico: <input type= 'text' id= 'nCivico' name= 'nCivico' placeholder= 'Numero Civico' required>
                            Citta': <input type= 'text' id= 'citta' name= 'citta' placeholder= 'Citta'>
                            <br>Telefono: <input type= 'text' id= 'telefono' name= 'telefono' placeholder= 'Telefono' required>
                            <br> <br>
                            Username: <input type= 'text' id= 'username' name= 'username' placeholder= 'username' required>
                            Email: <input type = 'mail' id = 'mail' name = 'mail' placeholder = 'mail' required>
                            Password: <input type= 'password' id= 'password' name= 'password' placeholder= 'password' required>
                            <input type='hidden'  name='tipo' value = 'prop'>
                        
                            <input type='submit' id='btn' name='btn' value='Sign-up'>
                        </form>

                    <%
                        String nomeP = request.getParameter("nome");
                        String cognomeP = request.getParameter("cognome");
                        String nomeLocaleP = request.getParameter("nomeLocale");
                        String viaP = request.getParameter("via");
                        String nCivicoP = request.getParameter("nCivico");
                        String cittaP = request.getParameter("citta");
                        String telefonoP = request.getParameter("telefono");
                        String usrP = request.getParameter("username");
                        String mailP = request.getParameter("mail");
                        String pswP = request.getParameter("password");

                        String queryVerifica2 = "SELECT * FROM Utente WHERE usr = '"+usrP+"';";
                        String queryInserisciUtente2 = "INSERT INTO Utente (usr,psw) VALUES ('"+usrP+"', '"+pswP+"')";    

                        ResultSet r1 = st.executeQuery(queryVerifica2);


                        if((usrP != null) || (pswP != null)){
                            if(r1.next()){
                                out.println("<p>Questo account è già esistente</p>");
                            }else{
                                st.executeUpdate(queryInserisciUtente2);

                                String queryID = "SELECT ID FROM Utente WHERE usr = '"+usrP+"'";
                                ResultSet r = st.executeQuery(queryID);
                                r.next();
                                String IDUtente = r.getString("ID");
                                System.out.println("ID: "+IDUtente);
                                String queryInserisciProp = "INSERT INTO Proprietario (IDUtente, nome, cognome, nomeLocale, via, nCivico, telefono, email) VALUES ('"+IDUtente+"','"+nomeP+"', '"+cognomeP+"', '"+nomeLocaleP+"', '"+viaP+"' , '"+nCivicoP+"', '"+telefonoP+"', '"+mailP+"')";
                                st.executeUpdate(queryInserisciProp);
                                response.sendRedirect("index.html"); 
                            }
                        }

                        break;
                    
                    default:
                        out.println(""); 

                }
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
        
        <a href = "index.html"> 
            <input type="button" value="Indietro"/> <br> 
        </a>

    </body>
</html>