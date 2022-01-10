<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Booking</title>

        <style>
            table, th, td {
                border: 1px solid black;
            }
            table {
                width: 100%;
            }

            .btn1{
                width: 100%;
            }
        </style>

        <script>
            function Prenota() {
                console.log("prenotazione effettuata"); // debug
            }

        </script>
    </head>
    
    <body>
        <h1>Booking</h1>
        <p>Visualizzazione tabella con i Parrucchieri disponibili, con possibilita' di scegliere quale andare a prenotare.</p>
        
        <%
        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        
        Connection connection=null;

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{
            
            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
            String query = "SELECT * FROM Proprietari"; 
            
            Statement st = connection.createStatement();
            ResultSet result = st.executeQuery(query);

            
            out.println("<table>");

                out.println("<tr>");
                    out.println("<th>Nome Locale</th>");
                    out.println("<th>Luogo</th>");
                    out.println("<th>Telefono</th>");
                    out.println("<th>Email</th>");
                    out.println("<th>Prenotazione</th>");
                out.println("</tr>");
                
                while(result.next()){
                    String luogo = result.getString(5) + " " +result.getString(6) + "/" + result.getString(7);
                    
                    out.println("<tr>");
                        out.println("<td>"+result.getString(4)+ "</td>");
                        out.println("<td>"+luogo+ "</td>");
                        out.println("<td>"+result.getString(9)+ "</td>");
                        out.println("<td>"+result.getString(3)+ "</td>");
                        out.println("<td> <input type= 'button' class = 'btn1' value= 'prenota' onclick='Prenota()'></td>");
                        out.println("</tr>");
                }
            out.println("</table>");
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

        <br>
        <a href = "loginCliente.html"> 
            <input type="button" value="Indietro"/> <br> 
        </a>

    </body>

</html>