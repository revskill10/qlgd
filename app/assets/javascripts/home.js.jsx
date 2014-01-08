/** @jsx React.DOM */

var hdata = [
	{tuan: 1, colapse: 'colapseOne', active: false, data: [
			{id: 1, thoi_gian: '6h30 12/08/2013', phong: 'A103', so_tiet: 3, ma_lop: 'ml', ten_mon_hoc: 'tm', alias_state: 'Bình thường', alias_status: 'Đang chờ', color: 'warning'},
			{id: 2, thoi_gian: '6h30 12/08/2013', phong: 'A103', so_tiet: 3, ma_lop: 'ml', ten_mon_hoc: 'tm', alias_state: 'Bình thường', alias_status: 'Được chấp nhận', color: 'info'},
			{id: 3, thoi_gian: '6h30 12/08/2013', phong: 'A103', so_tiet: 3, ma_lop: 'ml', ten_mon_hoc: 'tm', alias_state: 'Bình thường', alias_status: 'Đang chờ'}
		]},
	{tuan: 2, colapse: 'colapseTwo', active: true, data: [
			{id: 4, thoi_gian: '6h30 12/08/2013', phong: 'A103', so_tiet: 3, ma_lop: 'ml', ten_mon_hoc: 'tm', alias_state: 'Bình thường', alias_status: 'Đang chờ'},
			{id: 5, thoi_gian: '6h30 12/08/2013', phong: 'A103', so_tiet: 3, ma_lop: 'ml', ten_mon_hoc: 'tm', alias_state: 'Bình thường', alias_status: 'Đang chờ'}
		]},
	{tuan: 3, colapse: 'colapseThree', active: false, data: [
			{id: 6, thoi_gian: '6h30 12/08/2013', phong: 'A103', so_tiet: 3, ma_lop: 'ml', ten_mon_hoc: 'tm', alias_state: 'Bình thường', alias_status: 'Đang chờ'}
		]}
];
var Home2 = React.createClass({
	getInitialState: function(){
		return {data: []};
	},
	loadData: function(){
		$.ajax({
			url: "/lich_trinh_giang_days" ,
			success: function(data) {                      			
				this.setState({data: data});
			}.bind(this)
		});		
	},
	componentWillMount: function(){
		this.loadData();
	},	
	render: function(){
		var self = this;
		var x = this.state.data.map(function(d){
			return <Tuan colapse={d.colapse} active={d.active} key={d.tuan} tuan={d.tuan} data={d.data} />;
		});
		return (
			<div class="panel-group" id="accordion">
			    {x}
			</div>

		);
	}
});

var Tuan = React.createClass({
	render: function(){		
		var x = this.props.data.map(function(d){
			return <TuanRow key={'tuanrow' + d.id} data={d} />
		});
		return(
			<div class="panel panel-default">
			    <div class="panel-heading">
			      <h4 class="panel-title">
			        <a data-toggle="collapse" data-parent="#accordion" href={"#"+this.props.colapse}>
			          {"Tuần " + this.props.tuan}
			        </a>
			      </h4>
			    </div>
			    <div id={this.props.colapse} class={"panel-collapse collapse " + (this.props.active === true ? 'in' : '')}>
			      <div class="panel-body">
			      		<div class="table-responsive">
			 				<table class="table table-bordered">
			 					<thead>
			 						<td>Thứ</td><td>Thời gian</td><td>Tiết bắt đầu</td><td>Số tiết</td><td>Thực hành</td><td>Phòng</td><td>Mã lớp</td><td>Môn</td><td>Loại</td><td>Trạng thái</td>
			 					</thead>
			 					<tbody>
			 						{x}
			 					</tbody>
			 				</table>
			 			</div>
			      </div>
			    </div>
			  </div>
		);
	}
});

var TuanRow = React.createClass({	
	render: function(){
		var boldstyle = {'font-weight': this.props.data.active === true ? 'bold' : ''};
		return (
			<tr style={boldstyle} class={this.props.data.color}>
				<td>{this.props.data.thu}</td>
				<td><a href={'/lich/'+this.props.data.id}>{this.props.data.thoi_gian}</a></td>
				<td>{this.props.data.tiet_bat_dau}</td>
				<td>{this.props.data.so_tiet}</td>
				<td>{this.props.data.thuc_hanh === false ? 'Lý thuyết' : 'Thực hành'}</td>
				<td>{this.props.data.phong}</td>
				<td>{this.props.data.ma_lop}</td>
				<td>{this.props.data.ten_mon_hoc}</td>
				<td>{this.props.data.alias_state}</td>
				<td><span class={this.props.data.color_status}>{this.props.data.alias_status}</span></td>								
			</tr>
		);
	}
});
React.renderComponent(<Home2 />, document.getElementById('main'));