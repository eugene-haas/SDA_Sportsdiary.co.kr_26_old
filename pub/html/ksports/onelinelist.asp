


			<tr style="cursor:pointer" id="titlelist_<%=k_idx%>"   onmousedown="$('#contest tr:nth-child(2n-1)').css('background-color', 'white' ); $('#contest tr:nth-child(2n)').css('background-color', '#f7f9fb' ); $( '#titlelist_<%=k_idx%>' ).css( 'background-color', '#BFBFBF' ); mx.input_edit(<%=k_idx%>)">
				<td><%=k_idx%></td>
				<td class="date" ><%=k_GameS%>~<%=k_GameE%></td>
				<td class="name"  ><%=k_sido%></td>
				<td class="name"  ><%=k_stadium%></td>
				<td class="name"  ><%=k_sgb%></td>
				<td class="name"  ><%=k_sgbsub%></td>
				<td class="name"  ><%=k_title%></td>
				<td class="name"  ><%=k_Gamedatecnt%></td>
				<td class="g_btn green_btn2"><%=k_VOD%></td>
				<td class="number"  ><%=k_shotcnt%></td>
			</tr>
