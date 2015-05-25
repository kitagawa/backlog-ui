describe("CommandService",function(){
	beforeEach(module("App"));
	beforeEach(function(){
		inject(function($injector) {
	    commandService = $injector.get('commandService');
	  });
	});

	describe("merge_commands",function(){
		it("add_command",function(){
			command = new Command("update",{"value":"update"},1)
			commandService.store(command)
			expect(commandService.list().length).toEqual(1)
			expect(commandService.list()[0].data["value"]).toEqual("update")
		})

		it("merge_commands",function(){
			commandService.store(new Command("create",{"value": "test"}));
			commandService.store(new Command("update",{"value": "test"},1));
			commandService.store(new Command("update",{"value": "test"},2));
			
			commandService.store(new Command("update",{"value":"update"},1));
			command_list = commandService.list();
			// １つ目の方はコマンド名が違うので変更なし
			expect(command_list[0].data["value"]).toEqual("test");
			// ２つ目の方は値が更新
			expect(command_list[1].data["value"]).toEqual("update")
			// 3つ目の方はkeyが違うので変更なし
			expect(command_list[2].data["value"]).toEqual("test")

			expect(command_list.length).toEqual(3)
		})
	})
})