 /** @jsx React.DOM */

var TaoLop = React.createClass({
	getInitialState: function(){
		return {giang_viens: []}
	},
	loadData: function(){
		$.ajax({
			url: '/daotao/giang_viens',
			success: function(data){
				this.setState({giang_viens: data.giang_viens, ma_mons: data.ma_mons});
			}.bind(this)
		})
	},
	componentWillMount: function(){
		this.loadData();
	},
	componentDidMount: function(){
		//React.unmountAndReleaseReactRootNode(document.getElementById('lop3'));
		var self = this;
		React.renderComponent(<LopMonHoc />, document.getElementById('lop3'));		
		$("#gv").select2({
			data: self.state.giang_viens
		});
	},
	componentDidUpdate: function(){
		var self = this;
		$("#gv").select2({
			data: self.state.giang_viens
		});
	},
	render: function(){
		return (
			<div>
				<hr />
				<input type="text" ref="ma_lop" placeholder="Mã lớp" />
				<input type="text" ref="ma_lop" placeholder="Mã môn học" />
				<input type="text" ref="ma_lop" placeholder="Tên môn học" />
				<input type="hidden" id="gv" style={{width:"500px"}} class="input-xlarge" />
				<button class="btn btn-success" >Tạo lớp</button>
				<hr />
				<div id="lop3"></div>
			</div>
		);
	}
});
 var LopMonHoc = React.createClass({
 	getInitialState: function(){
 		return {data: []}
 	},
 	loadData: function(){
 		$.ajax({
 			url: '/daotao/lops',
 			success: function(data){
 				this.setState({data: data.lops});
 			}.bind(this)
 		})
 	},
 	componentWillMount: function(){
 		this.loadData();
 	}, 	
 	componentDidMount: function(){
 		var self = this;
 		$('#mytable').dataTable({
		  "sPaginationType": "bootstrap",
		  "bAutoWidth": false,
		  "bDestroy": true,		
		  "fnDrawCallback": function() {		  		
            	self.forceUpdate();        	
          }, 
		});
 	},
 	componentDidUpdate: function(){
 		$('#mytable').dataTable({
		  "sPaginationType": "bootstrap",
		  "bAutoWidth": false,
		  "bDestroy": true,	
		});
 	},
 	render: function(){
 		var x = this.state.data.map(function(d, index){
 			return <tr><td>{index+1}</td><td>{d.ma_lop}</td><td>{d.ten_mon_hoc}</td></tr>
 		});
		return (
			<div class="table-responsive">
				<h4>Hello</h4>
				<table class="table table-bordered" id="mytable">
					<thead>
						<tr class="success">
							<td>Stt</td>
							<td>Mã lớp</td>
							<td>Tên môn học</td>
						</tr>	
					</thead>
					<tbody>
						{x}
					</tbody>
				</table>
			</div>
		) 		
 	}
 });