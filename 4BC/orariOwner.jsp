<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html>
    <head>
        <title>Orario</title>
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
        <h1>Configurazione Orari</h1>

        <form action = "orariOwner.jsp" method = "POST">

            <select name = "giorno" id="giorno">
                <option value = "lunedi">Lunedi</option>
                <option value = "martedi">Martedi</option>
                <option value = "mercoledi">Mercoledi</option>
                <option value = "giovedi">Giovedi</option>
                <option value = "venerdi">Venerdi</option>
                <option value = "sabato">Sabato</option>
            </select> <br> <br>

            Orario Mattina: <input type= "text" id = "orarioM" name = "orarioM" placeholder = "8.00-12.00" required>
            Orario Pausa: <input type= "text" id = "pausa" name = "pausa" placeholder = "12.00-13.00" required>
            Orario Pomeriggio: <input type= "text" id = "orarioP" name = "orarioP" placeholder = "13.00-18.00" required>

            <br> <br>
            <input type = "submit" id = "btn" name = "btn" value = "Conferma">
        </form>
        <br>

        <%
        
        String usr = (String) request.getSession().getAttribute("username");
        String id = (String) request.getSession().getAttribute("id");
        
        if((usr == null) || (id == null))
            response.sendRedirect("index.html");
        
        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";
        
        String giorno = " ";
        String orarioM = " ";
        String pausa = " ";
        String orarioP = " ";
        String controlloModifica = "false";
        
        Connection connection=null;

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{
            
            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "Parrucchiere.accdb");

            giorno = request.getParameter("giorno");
            orarioM = request.getParameter("orarioM");
            pausa = request.getParameter("pausa");
            orarioP = request.getParameter("orarioP");

            /*  CONTROLLO INSERIMENTO CARATTERI VALIDI
            if((orarioM.contains(":")) || (orarioP.contains(":")) || (pausa.contains(":")) || (orarioM.contains(" ")) || (orarioP.contains(" ")) || (pausa.contains(" ")) ){
                orarioM = null;
                orarioP =  null;
                pausa = null;
            }*/

            if(request.getParameter("controlloModifica") != null){
                controlloModifica = request.getParameter("controlloModifica");
            }
            
            String querySelect = "SELECT * FROM Orari WHERE idProp = '"+id+"';";
            String queryInserimentoOrari = "INSERT INTO Orari(giorno,orarioMattina,orarioPomeriggio,orarioPausa,idProp) VALUES ('"+giorno+"' , '"+orarioM+"' , '"+orarioP+"' , '"+pausa+"' , '"+id+"')";
            String queryControlloGiorno = "SELECT giorno FROM Orari WHERE idProp = '"+id+"' AND giorno = '"+giorno+"';";

            Statement st = connection.createStatement();
            ResultSet r = st.executeQuery(querySelect);
            ResultSet r1 = st.executeQuery(queryControlloGiorno);
            
            
            if((orarioM != null) && (pausa != null) && (orarioP != null)){
                if(r1.next()){
                    out.println("<p>Giorno già programmato, scegliene un altro o modifica la tabella sottostante</p>");    
                }else{
                    st.executeUpdate(queryInserimentoOrari);
                    response.sendRedirect("orariOwner.jsp");
                }
            }else{
                out.println("<p>Inserisci i valori nei campi come nell'esempio soprastante</p>");
            }

            if(!controlloModifica.equals("true")){                
                out.println("<table>");
                    out.println("<tr>");
                        out.println("<th>Giorno</th>");
                        out.println("<th>Orario Mattina</th>");
                        out.println("<th>Orario Pausa</th>");
                        out.println("<th>Orario Pomeriggio</th>");
                        out.println("<th> <a href = 'orariOwner.jsp?controlloModifica=true'><button class = 'btn1'>Modifica</button></a></th>");
                    out.println("</tr>");
                    
                    while(r.next()){   
                        String idGiorno = r.getString("ID"); 
                            out.println("<tr>");
                                out.println("<td>"+r.getString("giorno")+ "</td>");
                                out.println("<td>"+r.getString("orarioMattina")+ "</td>");
                                out.println("<td>"+r.getString("orarioPausa")+ "</td>");
                                out.println("<td>"+r.getString("orarioPomeriggio")+ "</td>");
                           
                                out.println("<form action='elimina.jsp' method='POST'>");
                                    out.println("<input type='hidden' id='idGiorno' name='idGiorno' value = '"+idGiorno+"'>");
                                    out.println("<input type='hidden' id='tipo' name='tipo' value = 'orario'>");
                                    
                                    out.println("<td> <input type= 'submit' class = 'btn1' value= 'Elimina'></td>");
                                out.println("</form>");
                                
                            out.println("</tr>");
                    }
                out.println("</table>");
            }else{
                out.println("<table>");

                out.println("<tr>");
                    out.println("<th>Giorno</th>");
                    out.println("<th>Orario Mattina</th>");
                    out.println("<th>Orario Pausa</th>");
                    out.println("<th>Orario Pomeriggio</th>");
                    out.println("<th> <a href = 'orariOwner.jsp?controlloModifica=false'><button class = 'btn1'>Indietro</button></a></th>");
                out.println("</tr>");
                
                while(r.next()){   
                    String idGiorno = r.getString(1);
                    out.println("<tr>");
                        out.println("<form action='modifica.jsp' method = 'post'>");
                            out.println("<td><input type = 'text' id = 'giorno' name = 'giorno' value = '"+r.getString("giorno")+"'></td>");
                            out.println("<td><input type = 'text' id = 'orarioM' name = 'orarioM' value = '"+r.getString("orarioMattina")+"'></td>");
                            out.println("<td><input type = 'text' id = 'pausa' name = 'pausa' value = '"+r.getString("orarioPausa")+"'></td>");
                            out.println("<td><input type = 'text' id = 'orarioP' name = 'orarioP' value = '"+r.getString("orarioPomeriggio")+"'></td>");
                            
                            out.println("<input type='hidden' id='idGiorno' name='idGiorno' value = '"+idGiorno+"'>");
                            out.println("<input type='hidden' id='tipo' name='tipo' value = 'orario'>");

                            out.println("<td> <input type= 'submit' class = 'btn1' value= 'Salva'></td>");
                        out.println("</form>");        
                    out.println("</tr>");
                }
                out.println("</table>");
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

        <br> <br>
        <a href = "loginOwner.jsp"> 
            <input type="button" value="Home"/> <br> 
        </a>

    </body>

</html>