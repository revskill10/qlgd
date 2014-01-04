 /** @jsx React.DOM */

var Cell = React.createClass({        
        handleInput: function(e){
            this.props.onInput1(this.props.data.index);
        },
        handleBlur: function(e){                    
            var grade = this.refs.grade.getDOMNode().value;    
                var data = {index: this.props.data.index, assignment_id: this.props.data.assignment_id, sinh_vien_id: this.props.data.sinh_vien_id, grade: grade};
            this.props.onEnter(data);            
        },        
        handleKey: function(e){                
            if (this.props.data.edit == 1){        
                var grade = this.refs.grade.getDOMNode().value;    
                var data = {index: this.props.data.index, assignment_id: this.props.data.assignment_id, sinh_vien_id: this.props.data.sinh_vien_id, grade: grade};
                
                if (e.shiftKey && e.keyCode == 9) {// left                    
                    e.preventDefault();
                    this.props.onKeyPress(data, 'left');        
                } else if (e.keyCode == 38) {                                        
                    e.preventDefault();
                    this.props.onKeyPress(data, 'up');            
                } else if (e.keyCode == 9 && !e.shiftKey) {                    
                    e.preventDefault();
                    this.props.onKeyPress(data, 'right');        
                } else if (e.keyCode == 40) {                    
                    e.preventDefault();
                    this.props.onKeyPress(data, 'down');
                } else if (e.keyCode == 13 || e.keyCode == 27) {                    
                    e.preventDefault();
                    this.props.onEnter(data);
                }                                
            }
        },        
        componentDidUpdate: function(){
            if (this.props.data.edit === 1){                
                $('#mi').focus();
                $('#mi').val(this.props.data.grade);
            }            
        },
    render: function() {
        if (this.props.data.edit === 0) {
         return (
            <div ref="t" onClick={this.handleInput}>{this.props.data.grade} / {this.props.data.assignment_points}</div>
         );
        } else if (this.props.data.edit === 1) {
            return (
                <span>
                <input id="mi" ref="grade" onKeyDown={this.handleKey} onFocus={this.handleInput} onBlur={this.handleBlur}  type="text"  />
                    / {this.props.data.assignment_points}
                </span>
            );
        }
    }
});

var Row = React.createClass({
    
    render: function(){
        var self = this;
        var x = this.props.data.map(function(d){                        
                return <td><Cell key={d.sinh_vien_id + '-' + d.assignment_id + '-' + d.index} onKeyPress={self.props.handleKeyPress} data={d} onBlur1={self.props.handleBlur} onChange1={self.props.handleChange} onInput1={self.props.handleInput} onEnter={self.props.handleEnter} /></td>
        });
        return (
            <tr><td>{this.props.name}</td>{x}</tr>
            
        );
    }
});

var RowGroup = React.createClass({

    render: function(){
        var self = this;
        var x = this.props.data.map(function(d){
            return <td>{d.diem_trung_binh}</td>;            
        });
        return (
            <tr><td>{this.props.name}</td>{x}<td>{this.props.diem_qua_trinh}</td></tr>
        );
    }
});
var GRADE = {
    data : [
        [ {sinh_vien_id: 0, assignment_id: 0, grade: 0},{sinh_vien_id: 0, assignment_id: 1, grade: 1}],
        [ {sinh_vien_id: 1, assignment_id: 0, grade: 0},{sinh_vien_id: 1, assignment_id: 1, grade: 1}]
]};        


var Grade = React.createClass({
    getInitialState: function(){
        return {names: [], data: [], group_names: [], group_data: [], active: -1, active2: -1};
    },
    loadSubmissions: function(){
        $.ajax({
          url: "/lop/"+this.props.lop+"/submissions.json" ,
          success: function(data) {                      
            this.setState({names: data.names, group_names: data.group_names, data: data.results, group_data: data.group_results, active: -1});
          }.bind(this)
        });  
    },
    getStatus: function(d){
        if (this.state.active === d.index) {
            return 1;
        } else {
            return 0;
        }
    },
    saveToServer: function(data, index){
        var d = {
            giang_vien_id: this.props.giang_vien,
            assignment_id: data.assignment_id,
            sinh_vien_id: data.sinh_vien_id,
            grade: data.grade
        }
        $.ajax({
            url: "/lop/" + this.props.lop + "/submissions",
            type: 'POST',
            data: d,
            success: function(data) {             
                this.setState({names: data.names, data: data.results, group_data: data.group_results, group_names: data.group_names, active: index});  
            }.bind(this)           
        });
        return false;
    },
    handleEnter: function(data){
        this.saveToServer(data, -1);
    },
    handleInput: function(obj){                 
        this.setState({active: obj});
    },
    handleBlur: function(){
        this.setState({active: -1});
    },    
    handleKeyPress: function(data, stat){
        if (stat == 'left'){            
            this.saveToServer(data, data.index - 1);                
        } else if (stat == 'up') {
            this.saveToServer(data, data.index - this.state.names.length);
        } else if (stat == 'down') {
            this.saveToServer(data, data.index + this.state.names.length);
        } else if (stat == 'right') {            
            this.saveToServer(data, data.index + 1);                    
        }
    },
    componentWillMount: function(){
        this.loadSubmissions();
    },             
    render: function(){
            var self = this;
            var header_name = <th>Họ và tên</th>;
            var header_dqt = <th>Điểm quá trình</th>;
            var headers = this.state.names.map(function(d){
                return <th><div><strong>{d.name}</strong></div>
                    <ul><li>- Thang điểm {d.points}</li>
                    <li>- Nhóm {d.group_name}, {d.group_weight} %
                    </li></ul></th>;
            });
            var group_headers = this.state.group_names.map(function(d){
                return <th>{d.name} - {d.weight}</th>;
            });
            var y = this.state.data.map(function(d){
                    d.assignments.map(function(d2){
                            d2.edit = self.getStatus(d2);
                            return d2;
                    });
                    return d;
                });                
            var x = y.map(function(d){                        
                return <Row name={d.name} key={d.index} handleKeyPress={self.handleKeyPress} handleEnter={self.handleEnter}  handleInput={self.handleInput} handleBlur={self.handleBlur} data={d.assignments} />
            });    
            var z = this.state.group_data.map(function(d){
                return <RowGroup name={d.name} diem_qua_trinh={d.diem_qua_trinh} data={d.assignment_groups} />
            });      

            return (                
                <div>
                    <hr />
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>           
                                <tr>{header_name}{headers}</tr>
                            </thead>                
                            <tbody>
                                {x}
                            </tbody>
                        </table>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>           
                               <tr><th>Họ và tên</th>{group_headers}<th>Điểm quá trình</th></tr>
                            </thead>                
                            <tbody>
                                {z}
                            </tbody>
                        </table>
                    </div>
                </div>
            );
    }
});