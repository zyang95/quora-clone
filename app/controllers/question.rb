# Not actually necessary, just if someone is poking at the javascript
# and they see that we're sending stuff to '/askquestion' this will
# redirect them to the main page
get '/askquestion' do
  redirect '/'
end

post '/askquestion' do
  # Should add validation

  if logged_in?
    test = Question.new(user_id: session[:user_id], content: params[:content])
    if test.save
      'Success'
    else
      status(400)
      body('400: Malformed post')
    end
  else
    status(400)
    body('400: Not logged in')
  end
end

get('/question/:id') do
  @question = Question.find(params[:id])
  if @question
    erb :'users/q_and_a', layout: :'layouts/userpage'
  else
    @error = 'reeee'
  end
end



post('/answer') do
  begin
    raise('Not logged in') if (!logged_in?)
    # Question.find raises an exception if invalidId
    question = Question.find(params[:question_id])
    answer = Answer.new(user_id: session[:user_id], question_id: question.id,
      content: params[:content])
    update = answer.save
    raise('Malformed post') if !update
    'Success'
  rescue Exception => e
    status(400)
    p "Error: #{e.message}"
  end
end


HITS_PER_PAGE = 10

# remove this route as main page will link here
get '/main' do
  erb :'users/show', layout: :'layouts/userpage'
end