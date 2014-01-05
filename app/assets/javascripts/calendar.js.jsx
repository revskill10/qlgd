 /** @jsx React.DOM */


 var Calendar = React.createClass({

 	getInitialState: function(){
		return {data: []};
	},
	loadData: function(){
		$.ajax({
          url: "/lop/"+this.props.lop+"/"+this.props.giang_vien +"/lich_trinh_giang_days" ,
          success: function(data) {                      
            this.setState({data: data});
          }.bind(this)
        });  		
	},
	componentWillMount: function(){
		this.loadData();
	},
 	// remove, restore, edit, nghiday, accept, unaccept
 	/*loadData: function(){
 		/*var CDATA = [
			{tuan: 1, thoi_gian: '6h30 12/08/2013', so_tiet: 3, phong: 'C201', thuc_hanh: false, ten_mon_hoc: 'mm1', state: 'normal', status: 'accepted', can_edit: false, can_restore: false, can_remove: false, can_nghiday: false, can_accept: false, can_unaccept: true, complete: 'Chưa hoàn thành'},
			{tuan: 1, thoi_gian: '6h30 13/08/2013', so_tiet: 3, phong: 'C201', thuc_hanh: true, ten_mon_hoc: 'mm2', state: 'normal', status: 'waiting', can_edit: true, can_restore: false, can_remove: true, can_nghiday: true, can_accept: true, can_unaccept: false, complete: 'Đã hoàn thành'}
		 ];

 		this.setState({data: CDATA});
 		console.log(this.state.data);
 	},
 	*/
 	render: function(){
 		var x = this.state.data.map(function(d){
 			if (d.alias_state === 'Bổ sung') {
 				return <CalendarRowBosung data={d} />
 			}
 			if (d.alias_state === 'Nghỉ dạy') {
 				return <CalendarRowNghiday data={d} />
 			}
 			return <CalendarRow data={d} />;
 		});
 		return (
 			<div class="table-responsive">
 				<table class="table table-bordered">
 					<thead>
 						<td>Tuần</td><td>Thời gian</td><td>Phòng</td><td>Số tiết</td><td>Thực hành</td><td>Loại</td><td>Trạng thái</td><td>Thao tác</td>
 					</thead>
 					<tbody>
 						{x}
 					</tbody>
 				</table>
 			</div>
 		);
 	}
});

var CalendarRowNghiday = React.createClass({
	getInitialState: function(){
		return {edit: 0}
	},
	render: function(){
		if (this.state.edit === 0) {
			return (
				<tr>
					<td>{this.props.data.tuan}</td>
					<td>{this.props.data.thoi_gian}</td>
					<td>{this.props.data.phong}</td>
					<td>{this.props.data.so_tiet}</td>
					<td>{this.props.data.thuc_hanh === false ? "Lý thuyết" : "Thực hành"}</td>
					<td>{this.props.data.alias_state}</td>
					<td>{this.props.data.alias_status}</td>
					<td>
						<button onClick={this.onUnNghiday} style={{display: this.props.data.can_unnghiday === false ?  'none' : ''}} class="btn btn-sm btn-warning">Hủy đăng ký</button>
					</td>
				</tr>
			);
		}
	}
});
var CalendarRowBosung = React.createClass({

	getInitialState: function(){
		return {edit: 0}
	},
	render: function(){
		if (this.state.edit === 0) {
			return (
				<tr>
					<td>{this.props.data.tuan}</td>
					<td>{this.props.data.thoi_gian}</td>
					<td>{this.props.data.phong}</td>
					<td>{this.props.data.so_tiet}</td>
					<td>{this.props.data.thuc_hanh === false ? "Lý thuyết" : "Thực hành"}</td>
					<td>{this.props.data.alias_state}</td>
					<td>{this.props.data.alias_status}</td>
					<td>
						<button onClick={this.onEdit} style={{display: this.props.data.can_edit === false ?  'none' : ''}} class="btn btn-sm btn-success">Sửa</button>
						<button onClick={this.onRemove} style={{display: this.props.data.can_remove === false ?  'none' : ''}} class="btn btn-sm btn-danger">Xóa</button>
						<button onClick={this.onRestore} style={{display: this.props.data.can_restore === false ?  'none' : ''}} class="btn btn-sm btn-default">Phục hồi</button>
						<button onClick={this.onUncomplete} style={{display: this.props.data.can_uncomplete === false ?  'none' : ''}} class="btn btn-sm btn-primary">Hủy hoàn thành</button>
					</td>
				</tr>
			);
		}
	}
});
var CalendarRow = React.createClass({
	getInitialState: function(){
		return {edit: 0}
	},

	render: function(){

		if (this.state.edit === 0) {
			return (
				<tr>
					<td>{this.props.data.tuan}</td>
					<td>{this.props.data.thoi_gian}</td>
					<td>{this.props.data.phong}</td>
					<td>{this.props.data.so_tiet}</td>
					<td>{this.props.data.thuc_hanh === false ? "Lý thuyết" : "Thực hành"}</td>
					<td>{this.props.data.alias_state}</td>
					<td>{this.props.data.alias_status}</td>
					<td>
						<button onClick={this.onNghiday} style={{display: this.props.data.can_nghiday === false ?  'none' : ''}} class="btn btn-sm btn-warning">Đăng ký nghỉ</button>
						<button onClick={this.onEdit} style={{display: this.props.data.can_edit === false ?  'none' : ''}} class="btn btn-sm btn-success">Sửa</button>
						<button onClick={this.onRemove} style={{display: this.props.data.can_remove === false ?  'none' : ''}} class="btn btn-sm btn-danger">Xóa</button>
						<button onClick={this.onRestore} style={{display: this.props.data.can_restore === false ?  'none' : ''}} class="btn btn-sm btn-default">Phục hồi</button>
						<button onClick={this.onAccept} style={{display: this.props.data.can_accept === false ?  'none' : ''}} class="btn btn-sm btn-primary">Chấp nhận</button>
						<button onClick={this.onUncomplete} style={{display: this.props.data.can_uncomplete === false ?  'none' : ''}} class="btn btn-sm btn-primary">Hủy hoàn thành</button>
					</td>
				</tr>
			);
		}
	}
});

