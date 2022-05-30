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
        String usr = (String) request.getSession().getAttribute("username");
        if(usr == null){
            response.sendRedirect("index.html");
        }

        String DRIVER = "net.ucanaccess.jdbc.UcanaccessDriver";

        String controlloOrario = "false";
        int idProp = 0;
        String selezione = "";

        Connection connection=null;

        try{
            Class.forName(DRIVER);
        }
        catch (ClassNotFoundException e) {
            out.println("Errore: Impossibile caricare il Driver Ucanaccess");
        }
        try{
            
            if(request.getParameter("controlloOrario") != null){
                controlloOrario = request.getParameter("controlloOrario");
            }

            if(request.getParameter("selezione") != null){
                controlloOrario = request.getParameter("selezione");
            }

            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "Parrucchiere.accdb");
            String query = "SELECT * FROM Proprietario"; 
            
            Statement st = connection.createStatement();
            ResultSet result = st.executeQuery(query);

            
            if(controlloOrario.equals("false")){
                out.println("<table>");

                    out.println("<tr>");
                        out.println("<th>Nome Locale</th>");
                        out.println("<th>Luogo</th>");
                        out.println("<th>Telefono</th>");
                        out.println("<th>Email</th>");
                        out.println("<th>Prenotazione</th>");
                    out.println("</tr>");
                    
                    while(result.next()){
                        String luogo = result.getString("via") + " " +result.getString("nCivico") + "/" + result.getString("citta");
                        idProp = Integer.parseInt(result.getString("ID"));          
                        out.println("<tr>");
                            out.println("<td>"+result.getString("nomeLocale")+ "</td>");
                            out.println("<td>"+luogo+ "</td>");
                            out.println("<td>"+result.getString("telefono")+ "</td>");
                            out.println("<td>"+result.getString("email")+ "</td>");
                            
                            out.println("<td> <a href = 'booking.jsp?controlloOrario=true&idProprietario="+idProp+"'><button class = 'btn1'>Vedi Orario</button></a></td>");
                            out.println("</tr>");
                    }
                out.println("</table>");
            }else{
                    selezione = controlloOrario;
                    

                if(!selezione.equals("y")){

                result.next();
                idProp = Integer.parseInt(request.getParameter("idProprietario"));

                String querySelectProp = "SELECT * FROM Proprietario WHERE ID = '"+idProp+"'";

                String queryOrari = "SELECT orarioMattina,orarioPomeriggio FROM Orari WHERE idProp = '"+idProp+"';";
                String queryOrari2 = "SELECT * FROM Orari WHERE idProp = '"+idProp+"';";

                ResultSet r = st.executeQuery(querySelectProp);  
                ResultSet r1 = st.executeQuery(queryOrari); 
                ResultSet r2 = st.executeQuery(queryOrari2);

                
                out.println("<table>");

                    out.println("<tr>");
                        out.println("<th>Nome Locale</th>");
                        out.println("<th>Luogo</th>");
                        out.println("<th>Telefono</th>");
                        out.println("<th>Email</th>");
                        out.println("<th>Giorni Disponibili</th>");
                        
                        
                        //out.println("<td> <a href = 'booking.jsp?controlloOrario=true&selezione=y&idProprietario="+idProp+"'><button class = 'btn1'>Seleziona</button></a></td>");
                        
                    out.println("</tr>");
                    
                    while(r.next() && r1.next()){
                        String luogo = r.getString("via") + " " +r.getString("nCivico") + "/" + r.getString("citta");        
                        
                        out.println("<tr>");
                            out.println("<td>"+r.getString("nomeLocale")+ "</td>");
                            out.println("<td>"+luogo+ "</td>");
                            out.println("<td>"+r.getString("telefono")+ "</td>");
                            out.println("<td>"+r.getString("email")+ "</td>");
                            
                            out.println("<td>");
                                out.println("<form action = 'booking.jsp' method = 'POST'>");
                                    out.println("<select name = 'giorno' id='giorno'>");
                                        out.println("<option value = 'lunedi'>Lunedi</option>");
                                        out.println("<option value = 'martedi'>Martedi</option>");
                                        out.println("<option value = 'mercoledi'>Mercoledi</option>");
                                        out.println("<option value = 'giovedi'>Giovedi</option>");
                                        out.println("<option value = 'venerdi'>Venerdi</option>");
                                        out.println("<option value = 'sabato'>Sabato</option>");
                                    out.println("</select>");
                                    
                                    out.println("<input type='hidden' id='controlloOrario' name='controlloOrario' value = 'true'>");
                                    out.println("<input type='hidden' id='idProprietario' name='idProprietario' value = '"+idProp+"'>");
                                    out.println("<input type='hidden' id='selezione' name='selezione' value = 'y'>");

                                    out.println("<input type= 'submit' value= 'Seleziona'>");
                                out.println("</form>");

                            out.println("</td>");
                            
                        out.println("</tr>");
                    }
                out.println("</table>");
                
                out.println("<br><a href = 'booking.jsp?controlloOrario=false'><button class ='btn2'> Indietro </button></a>");
                }else{
                   String giorno = request.getParameter("giorno");
                    //FARE UNA SELECT IN BASE AL GIORNO E DARE IN OUTPUT GLI ORARI POSSIBILI PER LA PRENOTAZIONE
                    //SE IL GIORNO NON è PRESENTE SCRIVERLO
                    //AGGIUNGERE TASTO TORNA INDIETRO
/*
                    String querySelezioneGiorno = "SELECT orarioMattina, orarioPomeriggio, orarioPausa FROM Orari WHERE giorno = '"+giorno+"' AND idProp = '1';";
                    //String querySelezioneGiorno = "SELECT orarioMattina,orarioPomeriggio FROM Orari WHERE idProp = '"+idProp+"';";
                    System.out.println("aaaaaaaa:" + querySelezioneGiorno);

                    
                    ResultSet r3 = st.executeQuery("querySelezioneGiorno");
                    
                    r3.next();

                    String oMattino = r3.getString("orarioMattina"); 
                    String oPomeriggio = r3.getString("orarioPomeriggio"); 

                    String[] orarioM = oMattino.split("-");
                    double oraM1 = Double.parseDouble(orarioM[0]);
                    double oraM2 = Double.parseDouble(orarioM[1]);

                    //System.out.println("prima parte orario mattina: " + oraM1);  //debug
                    //System.out.println("seconda parte orario mattina: " + oraM2); //debug

                    String[] orarioP = oPomeriggio.split("-");
                    double oraP1 = Double.parseDouble(orarioP[0]);
                    double oraP2 = Double.parseDouble(orarioP[1]);
                    
                    int i = 0;
                    int j = 0;

                    out.println("<select name = 'orario' id='orario'>");
                    while(oraM1 < oraM2 ){    
                        i++;
                        j= i;
                        out.println("<option value = 'ora"+i+"'>"+oraM1+"</option>");
                        oraM1++;
                    }
                    while(oraP1 < oraP2){       
                        j++;
                        out.println("<option value = 'ora"+j+"'>"+oraP1+"</option>");
                        oraP1++;
                    }
                    out.println("</select>");
                 */   
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

        <br>
        <a href = "loginCliente.jsp"> 
            <br><input type="button" value="Home"/> <br> 
        </a>

    </body>

</html>