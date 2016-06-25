var ready = function () {

    /**
     * When the send message link on our home page is clicked
     * send an ajax request to our rails app with the sender_id and
     * recipient_id
     */

    $(document).on('click', '.start-conversation', function(e){
        e.preventDefault();
        $(document).find(".paginate_button").removeClass('active');
        var sender_id = $(this).data('sid');
        var recipient_id = $(this).data('rip');
        $.post('/conversations', { sender_id: sender_id, recipient_id: recipient_id }, function (data) {
            chatBox.chatWith(data.conversation_id);
        });
    });

    /**
     * Used to minimize the chatbox
     */

    $(document).on('click', '.toggleChatBox', function (e) {
        e.preventDefault();

        var id = $(this).data('cid');
        chatBox.toggleChatBoxGrowth(id);
    });

    $(document).on('click', '.acceptUser', function() {
        var userID = $(this).data('user-id');

        $.ajax ({
            url: '/admin/approve_registration',
            type: 'post',
            data: { user_id: userID },
            success: function(data) {
                $('.studentsTable').DataTable().ajax.reload();
                $('.teachersTable').DataTable().ajax.reload();
                setTimeout(addTooltip, 500);
            }
        })
    })

    /**
     * Used to close the chatbox
     */

    $(document).on('click', '.closeChat', function (e) {
        e.preventDefault();
        var id = $(this).data('cid');
        chatBox.close(id);
    });


    /**
     * Listen on keypress' in our chat textarea and call the
     * chatInputKey in chat.js for inspection
     */

    $(document).on('keydown', '.chatboxtextarea', function (event) {

        var id = $(this).data('cid');
        chatBox.checkInputKey(event, $(this), id);
    });

    $(document).on('click', '.sendMessage', function (event) {

        var id = $(this).parent().find('.chatboxtextarea').data('cid');
        chatBox.checkInputKey(event, $(this).parent().find('.chatboxtextarea'), id);
    });

    /**
     * When a conversation link is clicked show up the respective
     * conversation chatbox
     */

    $('a.conversation').click(function (e) {
        e.preventDefault();

        var conversation_id = $(this).data('cid');
        chatBox.chatWith(conversation_id);
    });


}

$(document).ready(ready);
$(document).on("page:load", ready);