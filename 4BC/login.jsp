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
        String tipo = null;
        String id = null;
        Connection connection=null;

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{

            tipo = request.getParameter("tipo");

            out.println("<form action='login.jsp' method='POST'>");
                out.println("<input type='text' id='username' name='username' placeholder='username'>");
                out.println("<input type='password' id='password' name='password'placeholder='password'>");
                out.println("<input type='hidden' id='tipo' name='tipo' value = '"+tipo+"'>");
                out.println("<input type='submit' id='btn' name='btn' value='Accedi'>");
            out.println("</form>");

            out.println("<input type='checkbox' onclick='mostraPsw()'>Show Password<br><br>");

            out.println("<a href = 'index.html'>");
                out.println("<input type='button' value='Indietro'/> <br> ");
            out.println("</a>");



            username = request.getParameter("username");
            password = request.getParameter("password");
            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
            
            String queryControlloC = "SELECT username FROM Clienti WHERE username = '"+username+"'AND password = '"+password+"';"; 
            String queryControlloP = "SELECT username FROM Proprietari WHERE username = '"+username+"'AND password = '"+password+"';";
            
            String querySelectC = "SELECT * FROM Clienti WHERE username = '"+username+"'AND password = '"+password+"';";
            String querySelectP = "SELECT * FROM Proprietari WHERE username = '"+username+"'AND password = '"+password+"';";

            System.out.println("tipo: "+tipo);  //debug
            System.out.println("username: "+username);  //debug
            System.out.println("password: "+ password);  //debug

            HttpSession s = request.getSession();
            
            Statement st = connection.createStatement();
            ResultSet r1 = st.executeQuery(queryControlloC);
            ResultSet r2 = st.executeQuery(queryControlloP);
            
            ResultSet r3 = st.executeQuery(querySelectC);
            ResultSet r4 = st.executeQuery(querySelectP);
            

            if(tipo.equals("cliente")){
                if(r1.next()){    
                    s.setAttribute("username", username);
                    r3.next();
                    id = r3.getString(5);
                    s.setAttribute("id", id);
                    response.sendRedirect("loginCliente.jsp"); 
                }else{
                    if((username != null) && (password != null)){
                        out.println("<p>Credenziali errate o inesistenti</p>");
                    }              
                }
            }else if(tipo.equals("prop")){
                if(r2.next()){
                    s.setAttribute("username", username);
                    r4.next();
                    id = r4.getString(8);
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