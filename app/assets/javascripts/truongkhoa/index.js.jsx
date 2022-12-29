 /** @jsx React.DOM */

var tkdata = [
	{giang_vien_id: 1, ten_giang_vien: 'gv1', data: [
			{lop_mon_hoc_id: 1, ma_lop: 'ma1', ten_mon_hoc: 'mon1', duyet_thong_so: false, duyet_lich_trinh: false, duyet_tinh_hinh: false}
		]
	},
	{giang_vien_id: 2, ten_giang_vien: 'gv2', data: [
			{lop_mon_hoc_id: 2, ma_lop: 'ma2', ten_mon_hoc: 'mon2', duyet_thong_so: false, duyet_lich_trinh: false, duyet_tinh_hinh: false},
			{lop_mon_hoc_id: 3, ma_lop: 'ma3', ten_mon_hoc: 'mon3', duyet_thong_so: false, duyet_lich_trinh: false, duyet_tinh_hinh: false}
		]
	}
];
 var Main = React.createClass({
 	getInitialState: function(){
 		return {data: []}
 	},
 	loadData: function(){
 		//this.setState({data: tkdata});
 		$.ajax({
 			url: '/truongkhoa/' + this.props.khoa_id,
 			method: 'GET',
 			success: function(data){
 				this.setState({data: data});
 			}.bind(this)
 		});
 	},
 	componentWillMount: function(){
 		this.loadData();
 	},
 	render: function(){ 		
 		var x = this.state.data.map(function(d, index){
 			return <TKGiangVien stt={index+1} giang_vien_id={d.giang_vien_id} ten_giang_vien={d.ten_giang_vien} data={d.data} />
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
 			<div class="panel panel-default">
	 			<div class="panel-heading">
			      <h4 class="panel-title">
			        <a data-toggle="collapse" data-parent="#accordion" href={"#gv"+this.props.giang_vien_id}>
			          {this.props.stt}: {this.props.ten_giang_vien}
			        </a>
			      </h4>
			    </div>
			    <div id={"gv"+this.props.giang_vien_id} class="panel-collapse collapse">
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
							<td>Thông số lớp học</td>
							<td>Lịch trình thực hiện</td>
							<td>Theo dõi tình hình</td>
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
 				<td><a href={"/lop/" + this.props.data.lop_mon_hoc_id}>{this.props.data.ma_lop}</a></td>
 				<td>{this.props.data.ten_mon_hoc}</td>
 				<td>{this.props.data.duyet_thong_so_status}</td>
 				<td>{this.props.data.duyet_lich_trinh_status}</td>
 				<td>{this.props.data.duyet_tinh_hinh_status}</td>
 			</tr>
 		)
 	}
 });
 React.renderComponent(<Main khoa_id={ENV.khoa_id} />, document.getElementById('tkmain'));