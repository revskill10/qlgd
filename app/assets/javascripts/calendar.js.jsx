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

 	handleNghiday: function(d){
 		d.giang_vien = this.props.giang_vien;
 		d.lop_id = this.props.lop;
 		$.ajax({
            url: "/lop/" + this.props.lop + "/lich_trinh_giang_days/nghiday",
	            type: 'POST',
	            data: d,
	            success: function(data) {             
	                this.setState({data: data, add: 0}); 
	            }.bind(this)           
	        });		
 	},
 	handleUnNghiday: function(d){
 		d.giang_vien = this.props.giang_vien;
 		d.lop_id = this.props.lop;
 		$.ajax({
            url: "/lop/" + this.props.lop + "/lich_trinh_giang_days/unnghiday",
	            type: 'POST',
	            data: d,
	            success: function(data) {             
	                this.setState({data: data, add: 0}); 
	            }.bind(this)           
	        });		
 	},
 	handleReport: function(d){
 		d.giang_vien = this.props.giang_vien;
 		d.lop_id = this.props.lop;
 		$.ajax({
            url: "/lop/" + this.props.lop + "/lich_trinh_giang_days/report",
	            type: 'POST',
	            data: d,
	            success: function(data) {             
	                this.setState({data: data, add: 0}); 
	                React.unmountAndReleaseReactRootNode(document.getElementById('bosung'));
            		React.renderComponent(<Bosung giang_vien={this.props.giang_vien} lop={this.props.lop} />
                , document.getElementById('bosung'));
	            }.bind(this)           
	        });		
 	}, 	
 	handleRemove: function(d){
 		d.giang_vien = this.props.giang_vien;
 		d.lop_id = this.props.lop;
 		$.ajax({
            url: "/lop/" + this.props.lop + "/lich_trinh_giang_days/remove",
	            type: 'POST',
	            data: d,
	            success: function(data) {             
	                this.setState({data: data, add: 0}); 
	                React.unmountAndReleaseReactRootNode(document.getElementById('bosung'));
            		React.renderComponent(<Bosung giang_vien={this.props.giang_vien} lop={this.props.lop} />
                , document.getElementById('bosung'));
	            }.bind(this)           
	        });	
 	},
 	handleRestore: function(d){
 		d.giang_vien = this.props.giang_vien;
 		d.lop_id = this.props.lop;
 		$.ajax({
            url: "/lop/" + this.props.lop + "/lich_trinh_giang_days/restore",
	            type: 'POST',
	            data: d,
	            success: function(data) {             
	                this.setState({data: data, add: 0}); 
	                React.unmountAndReleaseReactRootNode(document.getElementById('bosung'));
            		React.renderComponent(<Bosung giang_vien={this.props.giang_vien} lop={this.props.lop} />
                , document.getElementById('bosung'));
	            }.bind(this)           
	        });	
 	},
 	handleUpdate: function(d){
 		d.giang_vien = this.props.giang_vien;
 		d.lop_id = this.props.lop;
 		$.ajax({
            url: "/lop/" + this.props.lop + "/lich_trinh_giang_days/update",
	            type: 'POST',
	            data: d,
	            success: function(data) {             
	                this.setState({data: data, add: 0}); 
	            }.bind(this)           
	        });	
 	},
 	render: function(){
 		var self = this;
 		var x = this.state.data.map(function(d){
 			if (d.alias_state === 'Bổ sung') {
 				return <CalendarRowBosung onRemove={self.handleRemove} onRestore={self.handleRestore} onReport={self.handleReport} data={d} />
 			}
 			if (d.alias_state === 'Nghỉ dạy') {
 				return <CalendarRowNghiday onRemove={self.handleRemove} onRestore={self.handleRestore} onUnNghiday={self.handleUnNghiday}  data={d} />
 			}
 			return <CalendarRow onUpdate={self.handleUpdate} onRemove={self.handleRemove} onRestore={self.handleRestore} onComplete={self.handleComplete} onNghiday={self.handleNghiday} onReport={self.handleReport} data={d} />;
 		});
 		return (
 			<div class="table-responsive">
 				<table class="table table-bordered">
 					<thead>
 						<td>Tuần</td><td>Thời gian</td><td>Phòng</td><td>Số tiết</td><td>Thực hành</td><td>Loại</td><td>Trạng thái</td><td>Ghi chú</td><td>Thao tác</td>
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
	onUnNghiday: function(e){
		this.props.onUnNghiday(this.props.data);
	},
	onRemove: function(e){
		this.props.onRemove(this.props.data);
	},
	onRestore: function(e){	
		this.props.onRestore(this.props.data);
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
					<td>{this.props.data.note}</td>
					<td>
						<button onClick={this.onUnNghiday} style={{display: this.props.data.can_unnghiday === false ?  'none' : ''}} class="btn btn-sm btn-warning">Hủy đăng ký</button>
						<button onClick={this.onRemove} style={{display: this.props.data.can_remove === false ?  'none' : ''}} class="btn btn-sm btn-danger">Xóa</button>
						<button onClick={this.onRestore} style={{display: this.props.data.can_restore === false ?  'none' : ''}} class="btn btn-sm btn-default">Phục hồi</button>
					</td>
				</tr>
			);
		}
	}
});
var CalendarRowBosung = React.createClass({
	onUncomplete: function(e){
		this.props.onUncomplete(this.props.data);
	},
	onRestore: function(e){
		this.props.onRestore(this.props.data);
	},
	onRemove: function(e){
		this.props.onRemove(this.props.data);
	},
	render: function(){
		return (
			<tr>
				<td>{this.props.data.tuan}</td>
				<td>{this.props.data.thoi_gian}</td>
				<td>{this.props.data.phong}</td>
				<td>{this.props.data.so_tiet}</td>
				<td>{this.props.data.thuc_hanh === false ? "Lý thuyết" : "Thực hành"}</td>
				<td>{this.props.data.alias_state}</td>
				<td>{this.props.data.alias_status}</td>
				<td>{this.props.data.note}</td>
				<td>
					<button onClick={this.onRemove} style={{display: this.props.data.can_remove === false ?  'none' : ''}} class="btn btn-sm btn-danger">Xóa</button>
					<button onClick={this.onRestore} style={{display: this.props.data.can_restore === false ?  'none' : ''}} class="btn btn-sm btn-default">Phục hồi</button>
					<button onClick={this.onReport} style={{display: this.props.data.can_report === false ?  'none' : ''}} class="btn btn-sm btn-primary">Báo lỗi</button>
				</td>
			</tr>
		);
	}
});
var CalendarRow = React.createClass({
	getInitialState: function(){
		return {edit: 0}
	},
	onEdit: function(e){
		this.setState({edit: 1});
	},
	onCancelEdit: function(e){
		this.setState({edit: 0});
	},
	onUpdate: function(e){
		var note = this.refs.note.getDOMNode().value;
		var so_tiet = this.refs.so_tiet.getDOMNode().value;
		var phong =	this.refs.phong.getDOMNode().value;
		var thuc_hanh =	this.refs.thuc_hanh.getDOMNode().value;
		var data = {id: this.props.data.id, so_tiet: so_tiet, phong: phong, thuc_hanh: thuc_hanh}
		this.setState({edit: 0});
		this.props.onUpdate(data);
	},
	onReport: function(e){
		this.props.onReport(this.props.data);
	},	
	onRestore: function(e){
		this.props.onRestore(this.props.data);
	},
	onRemove: function(e){
		this.props.onRemove(this.props.data);
	},
	onNghiday: function(e){
		this.props.data.note = this.refs.note.getDOMNode().value
		this.props.onNghiday(this.props.data);
	},
	componentDidUpdate: function(e){
		this.refs.note.getDOMNode().value = this.props.data.note;
		if (this.state.edit === 1){
			this.refs.so_tiet.getDOMNode().value = this.props.data.so_tiet;
			this.refs.phong.getDOMNode().value = this.props.data.phong;	
			this.refs.thuc_hanh.getDOMNode().value = this.props.data.thuc_hanh;
		}	
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
					<td><input type="text" ref="note" placeholder="Ghi chú buổi học" /></td>
					<td>
						<button onClick={this.onNghiday} style={{display: this.props.data.can_nghiday === false ?  'none' : ''}} class="btn btn-sm btn-warning">Đăng ký nghỉ</button>
						<button onClick={this.onEdit} style={{display: this.props.data.can_edit === false ?  'none' : ''}} class="btn btn-sm btn-success">Sửa</button>
						<button onClick={this.onRemove} style={{display: this.props.data.can_remove === false ?  'none' : ''}} class="btn btn-sm btn-danger">Xóa</button>
						<button onClick={this.onRestore} style={{display: this.props.data.can_restore === false ?  'none' : ''}} class="btn btn-sm btn-default">Phục hồi</button>						
						<button onClick={this.onReport} style={{display: this.props.data.can_report === false ?  'none' : ''}} class="btn btn-sm btn-primary">Báo lỗi</button>
					</td>
				</tr>
			);
		} else {
			return (
				<tr>
					<td>{this.props.data.tuan}</td>
					<td>{this.props.data.thoi_gian}</td>
					<td>
						<input type="text" ref="phong" class="form-control input-sm" />
					</td>
					<td>
						<input type="text" ref="so_tiet" class="form-control input-sm" />
					</td>
					<td>
						<select ref="thuc_hanh" class="form-control input-sm">
							<option value="false">Lý thuyết</option>
							<option value="true">Thực hành</option>
						</select>
					</td>
					<td>{this.props.data.alias_state}</td>
					<td>{this.props.data.alias_status}</td>
					<td><input type="text" ref="note" placeholder="Ghi chú buổi học" /></td>
					<td>
						<button onClick={this.onCancelEdit} class="btn btn-sm btn-warning">Hủy</button>
						<button onClick={this.onUpdate} class="btn btn-sm btn-success">Cập nhật</button>
					</td>
				</tr>
			);
		}
	}
});

