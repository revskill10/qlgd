 /** @jsx React.DOM */

var Cell = React.createClass({
        getInitialState: function(){
                return {v: this.props.data.grade};
        },
        handleInput: function(e){
                this.props.onInput1(this.props.data.assignment_id, this.props.data.sinh_vien_id);
        },
        handleBlur: function(e){
                this.props.onBlur1();
        },        
        handleChange: function(e){
                this.setState({v: this.refs.v.getDOMNode().grade});
                this.props.data.grade = this.refs.v.getDOMNode().grade;
                this.props.onChange1(this.props.data);
        },        
        handleKey: function(e){
                if (e.keyCode == 37) {// left
                        this.props.onKeyPress(this.props.data.assignment_id, this.props.data.sinh_vien_id, 'left');        
                } else if (e.keyCode == 38) {
                        this.props.onKeyPress(this.props.data.assignment_id, this.props.data.sinh_vien_id, 'up');                
                } else if (e.keyCode == 39) {
                        this.props.onKeyPress(this.props.data.assignment_id, this.props.data.sinh_vien_id, 'right');        
                } else if (e.keyCode == 40) {
                        this.props.onKeyPress(this.props.data.assignment_id, this.props.data.sinh_vien_id, 'down');
                } else if (e.keyCode == 13) {
                        this.props.onEnter(this.props.data.assignment_id, this.props.data.sinh_vien_id, e.target.grade);
                }
        },        
        componentDidUpdate: function(){
                $('#mi').focus();
        },
    render: function() {
                if (this.props.data.edit === 0) {
                 return (
                 <div ref="t" onClick={this.handleInput}>{' ' + this.props.data.grade}</div>
                 );
                } else {
                        return (
                                <input id="mi" ref="v" onKeyPress={this.handleKey} onFocus={this.handleInput} onChange={this.handleChange} onBlur={this.handleBlur} type="text" grade={this.state.v} />
                        );
                }
    }
});

var Row = React.createClass({
    
    render: function(){
        var self = this;
                var x = this.props.data.map(function(d){                        
                        return <td><Cell key={d.sinh_vien_id + '-' + d.assignment_id} onKeyPress={self.props.handleKeyPress} data={d} onBlur1={self.props.handleBlur} onChange1={self.props.handleChange} onInput1={self.props.handleInput} onEnter={self.props.handleEnter} /></td>
                });
        return (
            <tr><td>{this.props.name}</td>{x}</tr>                        
            
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
        return {names: [], data: [], active: -1, active2: -1};
    },
    loadSubmissions: function(){
        $.ajax({
          url: "/lop/"+this.props.lop+"/submissions.json" ,
          success: function(data) {                      
            this.setState({names: data.names, data: data.results, active: -1, active2: -1});         
          }.bind(this)
        });  
    },
    getStatus: function(id, id2){
        if (this.state.active === id && this.state.active2 === id2) {
            return 1;
        } else {
            return 0;
        }
    },
    handleEnter: function(a, b, c){
            this.setState({active: -1, active2: -1});
            return false;
    },
    handleInput: function(obj, obj2){                 
        this.setState({active: obj, active2: obj2});
    },
    handleBlur: function(){
        this.setState({active: -1, active2: -1});
    },
    handleChange: function(d){
            return false;
    },
    handleKeyPress: function(obj, obj2, stat){
            if (stat == 'left'){
                    this.setState({active: obj - 1, active2: obj2});
            } else if (stat == 'up') {
                    this.setState({active: obj, active2: obj2 - 1});
            } else if (stat == 'down') {
                    this.setState({active: obj, active2: obj2 + 1});
            } else if (stat == 'right') {
                    this.setState({active: obj + 1, active2: obj2});
            }
    },
    componentWillMount: function(){
        this.loadSubmissions();
    },             
    render: function(){
            var self = this;
            var headers = this.state.names.map(function(d){
                return <td>{d.name}</td>;
            });
            var y = this.state.data.map(function(d){
                    d.assignments.map(function(d2){
                            d2.edit = self.getStatus(d2.assignment_id, d2.sinh_vien_id);
                            return d2;
                    });
                    return d;
                });                
            var x = y.map(function(d){                        
                    return <Row name={d.name} key={d.sinh_vien_id} handleKeyPress={self.handleKeyPress} handleEnter={self.handleEnter} handleChange={self.handleChange} handleInput={self.handleInput} handleBlur={self.handleBlur} data={d.assignments} />
            });            
            return (
                    <table class="table table-bordered"><thead>           
                    {headers}
                    </thead>
        <tbody>
        {x}</tbody>
        </table>
            );
    }
});