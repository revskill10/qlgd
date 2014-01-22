 /** @jsx React.DOM */

 var LopMonHoc = React.createClass({
 	loadData: function(){
 		$('#mytable').dynatable({
 			dataset: {
 				ajax: true,
 				ajaxUrl: '/daotao/lops.json',
 				ajaxOnLoad: true
 			}
 		});
 	},
 	componentDidMount: function(){
 		this.loadData();
 	},
 	render: function(){
		return (
			<div class="table-responsive">
				<table class="table table-bordered" id="mytable">
					<thead>
						<tr class="success">
							<td data-dynatable-column="ma_lop">Mã lớp</td>
							<td data-dynatable-column="ten_mon_hoc">Tên môn học</td>
						</tr>	
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		) 		
 	}
 });