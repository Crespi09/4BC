<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html>
    <head>
        <title>Sell</title>

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
            function Elimina() {
                console.log("Eliminazione Effettuata"); // debug
                <%
                    //fare query che elimina il prodotto, per il nome del proprietario usare lo username dalla sessione
                    
                %>
            }

            function Modifica() {
                console.log("Modifica Effettuata"); // debug
                <%
                    //query che mi va a modificare i dati nel database
                    
                %>
            }

        </script>

    </head>
    
    <body>
        <h1>SELL</h1>

        <form action = "sell.jsp" method = "POST">
            Nome: <input type= "text" id = "nome" name = "nome" placeholder = "Nome" required>
            Descrizione: <input type= "text" id = "descrizione" name = "descrizione" placeholder = "Descrizione" required>
            Quantita': <input type= "text" id = "quantita" name = "quantita" placeholder = "Quantita'" required>
            Prezzo: <input type= "text" id = "prezzo" name = "prezzo" placeholder = "Prezzo" required>

            <input type = "submit" id = "btn" name = "btn" value = "Aggiungi Prodotto" onclick ="Aggiungi()">        
        </form>

        <%

         String usr = (String) request.getSession().getAttribute("username");

        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        
        String nome = null;
        String descrizione = null;
        String quantita = null;
        String prezzo = null;

        Connection connection=null;

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{
            
            nome = request.getParameter("nome");
            descrizione = request.getParameter("descrizione");
            quantita = request.getParameter("quantita");
            prezzo = request.getParameter("prezzo");

            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "DatiUtenti.accdb");
            //query controllo se un prodotto è già stato inserito dallo stesso proprietario
            String query = "SELECT * FROM Prodotti"; 
            String queryControllo = "SELECT nome,proprietario FROM Prodotti WHERE nome = '"+nome+"' AND proprietario = '"+usr+"';";
            String queryInserimento = "INSERT INTO Prodotti(nome,descrizione,quantita,prezzo,proprietario) VALUES ('"+nome+"' , '"+descrizione+"' , '"+quantita+"' , '"+prezzo+"' , '"+usr+"')";
            String query2 = "SELECT proprietario FROM Prodotti WHERE proprietario = '"+usr+"';";

            Statement st = connection.createStatement();
            ResultSet r1 = st.executeQuery(queryControllo);
            ResultSet r3 = st.executeQuery(query);
            ResultSet r4 = st.executeQuery(query2);

            if((nome != null) || (descrizione != null) || (quantita != null) || (prezzo != null)){
                if(r1.next()){
                    out.println("<p>Prodotto già in vendita'</p>");
                }else{
                    st.executeUpdate(queryInserimento);
                    response.sendRedirect("sell.jsp"); 
                }
            }else{
                out.println("Inserisci i valori nei campi");
            }

            
            out.println("<p>Prodotti in vendita': </p>");
            out.println("<table>");

                out.println("<tr>");
                    out.println("<th>Nome</th>");
                    out.println("<th>Descrizione</th>");
                    out.println("<th>Quantita'</th>");
                    out.println("<th>Prezzo</th>");
                out.println("</tr>");
                
                while(r3.next()){   
                    if(r4.next()){   
                        out.println("<tr>");
                            out.println("<td>"+r3.getString(2)+ "</td>");
                            out.println("<td>"+r3.getString(5)+ "</td>");
                            out.println("<td>"+r3.getString(3)+ "</td>");
                            out.println("<td>"+r3.getString(4)+ "</td>");
                            out.println("<td> <input type= 'button' class = 'btn1' value= 'Modifica' onclick='Modifica()'></td>");
                            out.println("<td> <input type= 'button' class = 'btn1' value= 'Elimina' onclick='Elimina()'></td>");
                        out.println("</tr>");
                    }else{
                        break;
                    }
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

        <br> <br>
        <a href = "loginOwner.jsp"> 
            <input type="button" value="Indietro"/> <br> 
        </a>

    </body>

</html>