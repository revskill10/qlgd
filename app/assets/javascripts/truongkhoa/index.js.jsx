 /** @jsx React.DOM */

var tkdata = [
	{giang_vien_id: 1, ten_giang_vien: 'gv1', data: [
			{lop_mon_hoc_id: 1, ma_lop: 'ma1', ten_mon_hoc: 'mon1', status: false}
		]
	},
	{giang_vien_id: 2, ten_giang_vien: 'gv2', data: [
			{lop_mon_hoc_id: 2, ma_lop: 'ma2', ten_mon_hoc: 'mon2', status: true},
			{lop_mon_hoc_id: 3, ma_lop: 'ma3', ten_mon_hoc: 'mon3', status: true}
		]
	}
];
 var Main = React.createClass({
 	getInitialState: function(){
 		return {data: []}
 	},
 	loadData: function(){
 		this.setState({data: tkdata});
 	},
 	componentWillMount: function(){
 		this.loadData();
 	},
 	render: function(){ 		
 		var x = this.state.data.map(function(d){
 			return <TKGiangVien giang_vien_id={d.giang_vien_id} ten_giang_vien={d.ten_giang_vien} data={d.data} />
 		});
 		return ( 			
 				<div class="panel-group" id="accordion">
				  	{x}
				</div>				 			
 		)
 	}
 });
 var TKGiangVien = React.createClass({
 	render: function(){
 		return (
 			<div>
	 			<div class="panel-heading">
			      <h4 class="panel-title">
			        <a data-toggle="collapse" data-parent="#accordion" href={"#gv"+this.props.giang_vien_id}>
			          {this.props.ten_giang_vien}
			        </a>
			      </h4>
			    </div>
			    <div id={"gv"+this.props.giang_vien_id} class="panel-collapse collapse in">
				      <div class="panel-body">
				      		<TKLop data={this.props.data} />
				      </div>
			    </div>
		  </div>
 		)
 	}
 });
 var TKLop = React.createClass({
	render: function(){
		var x = this.props.data.map(function(d, index){
			return <TKLopRow stt={index} data={d} />
		});
		return (
			<div class="table-responsive">
				<table class="table table-bordered">
					<thead>
						<tr class="success">
							<td>Stt</td>
							<td>Mã lớp</td>
							<td>Tên môn học</td>
							<td>Tình trạng</td>
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
 var TKLopRow = React.createClass({
 	render: function(){
 		return (
 			<tr class={this.props.stt % 2 === 0 ? 'warning' : 'danger'}>
 				<td>{this.props.stt}</td>
 				<td><a href={"/tk/lop/" + this.props.data.lop_mon_hoc_id}>{this.props.data.ma_lop}</a></td>
 				<td>{this.props.data.ten_mon_hoc}</td>
 				<td>{this.props.data.status}</td>
 			</tr>
 		)
 	}
 });
 React.renderComponent(<Main khoa_id={ENV.khoa_id} />, document.getElementById('tkmain'));