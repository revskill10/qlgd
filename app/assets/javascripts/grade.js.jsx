 /** @jsx React.DOM */

var Cell = React.createClass({
        getInitialState: function(){
                return {v: this.props.data.value};
        },
        handleInput: function(e){
                this.props.onInput1(this.props.data.assignment_id, this.props.data.sinh_vien_id);
        },
        handleBlur: function(e){
                this.props.onBlur1();
        },        
        handleChange: function(e){
                this.setState({v: this.refs.v.getDOMNode().value});
                this.props.data.value = this.refs.v.getDOMNode().value;
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
                        this.props.onEnter(this.props.data.assignment_id, this.props.data.sinh_vien_id, e.target.value);
                }
        },        
        componentDidUpdate: function(){
                $('#mi').focus();
        },
    render: function() {
                if (this.props.data.edit === 0) {
                 return (
                 <div ref="t" onClick={this.handleInput}>{this.props.data.value}</div>
                 );
                } else {
                        return (
                                <input id="mi" ref="v" onKeyPress={this.handleKey} onFocus={this.handleInput} onChange={this.handleChange} onBlur={this.handleBlur} type="text" value={this.state.v} />
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
            <tr>{x}</tr>                        
            
        );
    }
});
var GRADE = {
    data : [
        [ {sinh_vien_id: 0, assignment_id: 0, value: 0},{sinh_vien_id: 0, assignment_id: 1, value: 1}],
        [ {sinh_vien_id: 1, assignment_id: 0, value: 0},{sinh_vien_id: 1, assignment_id: 1, value: 1}]
]};        


var Grade = React.createClass({
        getInitialState: function(){
        return {active: -1, active2: -1};
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
        render: function(){
                var self = this;
                var y = this.props.data.map(function(d){
                        return d.map(function(d2){
                                d2.edit = self.getStatus(d2.assignment_id, d2.sinh_vien_id);
                                return d2;
                        });
                });                
                var x = y.map(function(d){                        
                        return <Row key={d.sinh_vien_id} handleKeyPress={self.handleKeyPress} handleEnter={self.handleEnter} handleChange={self.handleChange} handleInput={self.handleInput} handleBlur={self.handleBlur} data={d} />
                });
                return (
                        <table>
            <tbody>
            {x}</tbody>
            </table>
                );
        }
});