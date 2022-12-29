/** @jsx React.DOM */


var ThanhTra = React.createClass({
  getInitialState: function(){
    return {data: []}
  },    
  loadData: function(){    
    $.ajax({
      url: '/teacher/lich_trinh_giang_days/thanhtra',
      success: function(data){        
        this.setState({data: data})
      }.bind(this)
    });
  },
  handleUpdate: function(d){    
    $.ajax({
      url: '/teacher/lich_trinh_giang_days/thanhtraupdate',
      type: 'POST',
      data: d,
      success: function(data){          
        this.setState({data: data});
      }.bind(this)
    });
  },
  handleAccept: function(d){
    $.ajax({
      url: '/teacher/lich_trinh_giang_days/accept',
      type: 'POST',
      data: d,
      success: function(data){          
        this.setState({data: data});
      }.bind(this)
    });
  },
  handleRequest: function(d){
    $.ajax({
      url: '/teacher/lich_trinh_giang_days/request',
      type: 'POST',
      data: d,
      success: function(data){          
        this.setState({data: data});
      }.bind(this)
    });
  },
  componentWillMount: function(){
    this.loadData();
  },
  render: function(){
    var self = this;
    if (this.state.data.length > 0) {
      var x = this.state.data.map(function(d, index){
        return <ThanhTraRow date={self.state.date} onAccept={self.handleAccept} onRequest={self.handleRequest} onUpdate={self.handleUpdate} data={d} stt={index+1} color={index % 2 === 0 ? 'danger' : 'warning'} />
      });    
      return (
        <div>          
          <hr />
          <div class="table-responsive">      
            <table class="table table-bordered">
              <colgroup>
                <col style={{width: "5%"}} />
                <col style={{width: "30%"}} />
                <col style={{width: "10%"}} />
                <col style={{width: "15%"}} />
                <col style={{width: "15%"}} />
                <col style={{width: "15%"}} />
                <col style={{width: "10%"}} />
              </colgroup>
              <thead>
                <tr class="success">
                  <td>Stt</td><td>Giờ học</td><td>Báo lỗi</td><td>Note 1</td><td>Note 2</td><td>Note 3</td><td>Thao tác</td>
                </tr>
              </thead>
              <tbody>
                {x}
              </tbody>
            </table>
          </div>
        </div>
      );        
    }   else {
      return (
        <div></div>
      )
    } 
  }
});

var ThanhTraRow = React.createClass({
  getInitialState: function(){
    return {edit: 0};
  },  
  onEdit: function(){
    this.setState({edit: 1});
  },
  onCancel: function(){
    this.setState({edit: 0});
  },
  onUpdate: function(){
    this.setState({edit: 0});
    var note2 = this.refs.note2.getDOMNode().value;    
    this.props.onUpdate({lich_id: this.props.data.id, note2: note2});
  },  
  onAccept: function(){
    this.props.onAccept({lich_id: this.props.data.id});
  },
  onRequest: function(){
    this.props.onRequest({lich_id: this.props.data.id});
  },
  componentDidUpdate: function(){
    if (this.state.edit === 1){
      this.refs.note2.getDOMNode().value = this.props.data.note2;      
    }
  },
  render: function(){
    if (this.state.edit === 0){
      return (      
        <tr class={this.props.color}>
          <td>{this.props.stt}</td>
          <td><span dangerouslySetInnerHTML={{__html: this.props.data.info}} /></td>
          <td><span class={this.props.data.di_muon_color}>{this.props.data.di_muon_alias}</span><br/><br/><span class={this.props.data.ve_som_color}>{this.props.data.ve_som_alias}</span><br/><br/><span class={this.props.data.bo_tiet_color}>{this.props.data.bo_tiet_alias}</span></td>
          <td><span dangerouslySetInnerHTML={{__html: this.props.data.note1_html}} /></td>
          <td><span dangerouslySetInnerHTML={{__html: this.props.data.note2_html}} /></td>
          <td><span dangerouslySetInnerHTML={{__html: this.props.data.note3_html}} /></td>
          <td>
            <button style={{display: this.props.data.can_giang_vien_edit === true ? '' : 'none'}} onClick={this.onEdit} class="btn btn-sm btn-success">Edit</button>
            <button style={{display: this.props.data.can_accept === true ? '' : 'none'}} onClick={this.onAccept} class="btn btn-sm btn-primary">Chấp nhận</button>
            <button style={{display: this.props.data.can_request === true ? '' : 'none'}} onClick={this.onRequest} class="btn btn-sm btn-warning">Yêu cầu xác minh</button>            
          </td>
        </tr>
      );
    } else {
      return (
        <tr class={this.props.color}>
          <td>{this.props.stt}</td>
          <td><span dangerouslySetInnerHTML={{__html: this.props.data.info}} /></td>
          <td><span class={this.props.data.di_muon_color}>{this.props.data.di_muon_alias}</span><br/><br/><span class={this.props.data.ve_som_color}>{this.props.data.ve_som_alias}</span><br/><br/><span class={this.props.data.bo_tiet_color}>{this.props.data.bo_tiet_alias}</span></td>
          <td>{this.props.data.note1}</td>
          <td><textarea ref="note2" style={{width:"100%", height: "200px"}} /></td>
          <td>{this.props.data.note3}</td>
          <td>
            <button onClick={this.onCancel} class="btn btn-sm btn-default">Hủy</button>
            <button onClick={this.onUpdate} class="btn btn-sm btn-success">Cập nhật</button>
            <button style={{display: this.props.data.can_giang_vien_edit === true ? '' : 'none'}} onClick={this.onEdit} class="btn btn-sm btn-success">Edit</button>
            <button style={{display: this.props.data.can_accept === true ? '' : 'none'}} onClick={this.onAccept} class="btn btn-sm btn-primary">Chấp nhận</button>
            <button style={{display: this.props.data.can_request === true ? '' : 'none'}} onClick={this.onRequest} class="btn btn-sm btn-warning">Yêu cầu xác minh</button>
          </td>
        </tr>
      );
    }
    
  }
});