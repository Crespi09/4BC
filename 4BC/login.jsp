<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Sign-in</title>

        <script>
            function mostraPsw(){
                var x = document.getElementById("password");
                if (x.type === "password") {
                    x.type = "text";
                } else {
                    x.type = "password";
                }
            }
        </script>

    </head>
    <body>
        <h1>Sign-in</h1>
        
        <%

        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        
        String username=null;
        String password=null;
        String id = null;
        String tipo = null;

        Connection connection=null;

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{

            out.println("<form action='login.jsp' method='POST'>");
                out.println("<input type='text' id='username' name='username' placeholder='username'>");
                out.println("<input type='password' id='password' name='password'placeholder='password'>");
                
                out.println("<input type='submit' id='btn' name='btn' value='Accedi'>");
            out.println("</form>");

            out.println("<input type='checkbox' onclick='mostraPsw()'>Show Password<br><br>");

            out.println("<a href = 'index.html'>");
                out.println("<input type='button' value='Indietro'/> <br> ");
            out.println("</a>");

            username = request.getParameter("username");
            password = request.getParameter("password");
            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "Parrucchiere.accdb");
            
            String queryControllo = "SELECT usr FROM Utente WHERE usr = '"+username+"'AND psw = '"+password+"';"; 
            
            String querySelect = "SELECT * FROM Utente WHERE usr = '"+username+"'AND psw = '"+password+"';";
            String querySelect2 = "SELECT * FROM Utente WHERE usr = '"+username+"'AND psw = '"+password+"';";

            System.out.println("username: "+username);  //debug
            System.out.println("password: "+ password);  //debug

            HttpSession s = request.getSession();
            
            Statement st = connection.createStatement();
            ResultSet r1 = st.executeQuery(queryControllo);
            
            ResultSet r3 = st.executeQuery(querySelect);
            ResultSet r6 = st.executeQuery(querySelect2);

            r6.next();
            id = r6.getString("ID");

            String queryControlloC = "SELECT ID FROM Utente INNER JOIN Cliente ON Utente.ID = Cliente.IDUtente WHERE ID = '"+Integer.parseInt(id)+"';";
            String queryControlloP = "SELECT ID FROM Utente INNER JOIN Proprietario ON Utente.ID = Proprietario.IDUtente WHERE ID = '"+Integer.parseInt(id)+"';";

            ResultSet r4 = st.executeQuery(queryControlloC);
            ResultSet r5 = st.executeQuery(queryControlloP);

            if(r4.next()){
                tipo = "cliente";
            }else if(r5.next()){
                tipo = "prop";
            }else{
                tipo = null;
            }

            System.out.println("TIPO:" + tipo);
            
            if(tipo.equals("cliente")){
                if(r1.next()){    
                    s.setAttribute("username", username);
                    r3.next();
                    id = r3.getString("ID");
                    s.setAttribute("id", id);
                    response.sendRedirect("loginCliente.jsp"); 
                }else{
                    if((username != null) && (password != null)){
                        out.println("<p>Credenziali errate o inesistenti</p>");
                    }              
                }
            }else if(tipo.equals("prop")){
                if(r1.next()){
                    s.setAttribute("username", username);
                    r3.next();
                    id = r3.getString("ID");
                    s.setAttribute("id", id); 
                    response.sendRedirect("loginOwner.jsp");
                }else{
                    if((username != null) && (password != null)){
                        out.println("<p>Credenziali errate o inesistenti</p>");
                    }              
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