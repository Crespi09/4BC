<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
    <head>
        <title>Buy</title>
    </head>

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
    
    <body>
        <h1>BUY</h1>
        <p> Visualizzazione tabella con prodotti disponibili all'acquisto, con possibilita' di scegliere quale andare a comprare.</p> <br>

        <%
            String tmp = (String) request.getSession().getAttribute("username");
            if(tmp == null){
                 response.sendRedirect("index.jsp");
            }

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
            String querySelezionaProdotti = "SELECT * FROM Prodotti"; 
            
            Statement st = connection.createStatement();
            ResultSet r = st.executeQuery(querySelezionaProdotti);

            
             out.println("<table>");

                out.println("<tr>");
                    out.println("<th>Nome</th>");
                    out.println("<th>Descrizione</th>");
                    out.println("<th>Quantita'</th>");
                    out.println("<th>Prezzo</th>");
                out.println("</tr>");
                
                while(r.next()){   
                     String idProd = r.getString(1); 
                     System.out.println("id:"+idProd);
                        out.println("<tr>");
                            out.println("<td>"+r.getString(2)+ "</td>");
                            out.println("<td>"+r.getString(4)+ "</td>");
                            out.println("<td>"+r.getString(6)+ "</td>");
                            out.println("<td>"+r.getString(7)+ " €</td>");
                            out.println("<td><input type = 'number' id= 'quantita' name = 'quantita' min = '1' max = '100' placeholder = 'quantita'></td>");
                            out.println("<td> <input type= 'submit' class = 'btn1' value= 'Aggiungi al Carrello'></td>");
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
        <a href = "loginCliente.jsp"> 
            <input type="button" value="Indietro"/> <br> 
        </a>
    </body>

</html>