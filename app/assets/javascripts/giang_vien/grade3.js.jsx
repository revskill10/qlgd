/** @jsx React.DOM */


var Grade2 = React.createClass({
	getInitialState: function(){
		return {data: [], headers: []}
	},
	loadData: function(){
		
		$.ajax({
          url: "/teacher/lop/"+this.props.lop+"/submissions2.json" ,
          success: function(data) {                      
            this.setState({data: data.results, headers: data.headers});
            React.unmountAndReleaseReactRootNode(document.getElementById('grades2'));
            React.renderComponent(<GroupGrade lop={this.props.lop} />, document.getElementById('grades2'));
          }.bind(this)
        }); 
	},
	onUpdate: function(d){
		$.ajax({
            url: "/teacher/lop/" + this.props.lop + "/submissions2",
            type: 'POST',
            data: d,
            success: function(data) {             
                this.setState({data: data.results, headers: data.headers});               
                React.unmountAndReleaseReactRootNode(document.getElementById('assignment'));
                React.renderComponent(<Assignments lop={this.props.lop} />, document.getElementById('assignment'));
                React.unmountAndReleaseReactRootNode(document.getElementById('grades2'));
                React.renderComponent(<GroupGrade lop={this.props.lop} />, document.getElementById('grades2'));
            }.bind(this)           
        });
        return false;
	},
	calDCC: function(){
		$.ajax({
          url: "/teacher/lop/"+this.props.lop+"/submissions/diem_chuyen_can.json",
          type: 'POST',
          success: function(data) {                      
            this.setState({data: data.results, headers: data.headers});
            React.unmountAndReleaseReactRootNode(document.getElementById('grades2'));
            React.renderComponent(<GroupGrade lop={this.props.lop} />, document.getElementById('grades2'));
          }.bind(this)
        }); 
	},
	componentWillMount: function(){
		this.loadData();
	},
	render: function(){
		var self = this;
		var headers = this.state.headers.map(function(d){
			return <td>{d.assignment_name} ({d.points})</td>
		});
		var x = this.state.data.map(function(d){
			return <GradeRow hovaten={d.hovaten} code={d.code} ma_lop_hanh_chinh={d.ma_lop_hanh_chinh} diem_qua_trinh={d.diem_qua_trinh} tinhhinh={d.tinhhinh}  onUpdate={self.onUpdate} data={d.submissions} />
		});
		return (
			<div>
				<button class="btn btn-sm btn-primary" onClick={this.calDCC}>Tính điểm chuyên cần (cột điểm đầu tiên)</button>
				<div class="table-responsive">
				<table class="table table-bordered">
					<thead>
						<tr class="success"><td>Họ và tên</td>
						<td>Tình hình đi học</td>
						{headers}
						<td>Điểm quá trình</td></tr>
					</thead>
					<tbody>
						{x}
					</tbody>
				</table>
				</div>
			</div>
		);
	}
});

var GroupGrade = React.createClass({
	getInitialState: function(){
		return {data: [], headers: []}
	},
	loadData: function(){
		$.ajax({
			url: '/teacher/lop/' + this.props.lop + '/group_submissions',
			success: function(data){
				this.setState({data: data.results, headers: data.headers});
			}.bind(this)
		})
	},
	componentWillMount: function(){
		this.loadData();
	},
	render: function(){
		var headers = this.state.headers.map(function(d){
			return <td>{d.group_name} ({d.weight}%)</td>
		});
		var x = this.state.data.map(function(d){
			return <GroupGradeRow hovaten={d.hovaten} code={d.code} tinhhinh={d.tinhhinh} ma_lop_hanh_chinh={d.ma_lop_hanh_chinh} diem_qua_trinh={d.diem_qua_trinh} data={d.group_submissions} />
		});
		return(			
			<div class="table-responsive">
				<table class="table table-bordered">
					<thead>
						<tr class="success"><td>Họ và tên</td><td>Tình hình đi học</td>{headers}<td>Điểm quá trình</td></tr>
					</thead>
					<tbody>
						{x}
					</tbody>
				</table>
			</div>			
		);
	}
});

var GroupGradeRow = React.createClass({
	render: function(){
		var x = this.props.data.map(function(d){
			return <GroupGradeCell data={d} />
		});
		return (
			<tr>
				<td><div>{this.props.hovaten}<br/>{this.props.code}<br/>{this.props.ma_lop_hanh_chinh}</div></td>
				<td><div class="progress">
        <div class="progress-bar progress-bar-success" style={{width: 100 - this.props.tinhhinh +"%"}}>
          <span>{100 - this.props.tinhhinh +"%"}</span>
        </div>        
        <div class="progress-bar progress-bar-danger" style={{width: this.props.tinhhinh + "%"}}>
          <span>{this.props.tinhhinh +"%"}</span>
        </div>
      </div></td>
				{x}
				<td>{this.props.diem_qua_trinh}</td>
			</tr>
		);
	}
});
var GroupGradeCell = React.createClass({
	render: function(){
		return (
			<td>{this.props.data.grade}</td>
		);
	}
});
var GradeRow = React.createClass({

	render: function(){
		var self = this;
		var x = this.props.data.map(function(d){
			return <GradeCell onUpdate={self.props.onUpdate} data={d} />
		});
		return (
			<tr>
				<td><div>{this.props.hovaten}<br/>{this.props.code}<br/>{this.props.ma_lop_hanh_chinh}</div></td>
				<td><div class="progress">
        <div class="progress-bar progress-bar-success" style={{width: 100 - this.props.tinhhinh +"%"}}>
          <span>{100 - this.props.tinhhinh +"%"}</span>
        </div>        
        <div class="progress-bar progress-bar-danger" style={{width: this.props.tinhhinh + "%"}}>
          <span>{this.props.tinhhinh +"%"}</span>
        </div>
      </div></td>
				{x}
				<td>{this.props.diem_qua_trinh}</td>
			</tr>
		);
	}
});

var DisabledGradeCell = React.createClass({
	render: function(){
		return (
			<td><div>{this.props.data.grade}</div>
			 <button class="btn btn-sm btn-primary" onClick={this.props.onEdit}>Sửa</button> </td>
		)
	}
});
var LiveGradeCell = React.createClass({
	onUpdate: function(){
		this.props.data.grade = this.refs.grade.getDOMNode().value;
		this.props.onUpdate(this.props.data);
	},	
	render: function(){
		return (
			<td>
				<input type="text" ref="grade" id="grade" />
				<button class="btn btn-danger" onClick={this.props.onCancel}>Hủy</button>
				<button class="btn btn-success" onClick={this.onUpdate}>Cập nhật</button>
			</td>
		);
	}
});
var GradeCell = React.createClass({
	getInitialState: function(){
		return {edit: 0}
	},
	onEdit: function(){
		this.setState({edit: 1});
	},
	onCancel: function(){
		this.setState({edit: 0});
	},
	onUpdate: function(d){
		this.setState({edit: 0});
		this.props.onUpdate(d);
	},
	componentDidUpdate: function(){
		if (this.state.edit === 1) {
			$("#grade").focus();
			$("#grade").val(this.props.data.grade);			
		}		
	},
	render: function(){
		
			if (this.state.edit === 0 ) {
			  return ( <DisabledGradeCell data={this.props.data} onEdit={this.onEdit} /> );
			} else {
			  return ( <LiveGradeCell data={this.props.data} onCancel={this.onCancel} onUpdate={this.onUpdate} /> ) ;
			}
		
	}
});