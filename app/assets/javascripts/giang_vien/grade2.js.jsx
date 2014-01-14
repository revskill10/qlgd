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
            }.bind(this)           
        });
        return false;
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
			return <GradeRow hovaten={d.hovaten} code={d.code} ma_lop_hanh_chinh={d.ma_lop_hanh_chinh}  onUpdate={self.onUpdate} data={d.submissions} />
		});
		return (
			<table class="table table-bordered">
				<thead>
					<tr class="success"><td>Họ và tên</td>{headers}</tr>
				</thead>
				<tbody>
					{x}
				</tbody>
			</table>
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
			<tr><td>{this.props.hovaten}</td>{x}</tr>
		);
	}
});

var DisabledGradeCell = React.createClass({
	render: function(){
		return (
			<td><div onClick={this.props.onEdit} >{this.props.data.grade}</div></td>
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
				<button class="btn btn-danger curl-top-left" onClick={this.props.onCancel}>Hủy</button>
				<button class="btn btn-success curl-top-left" onClick={this.onUpdate}>Cập nhật</button>
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