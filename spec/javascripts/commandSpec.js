describe("Command",function(){
	describe("merge_commands",function(){
		it("add_command",function(){
			command = new Command("update",{"value":"update"},1)
			command_list = [];
			Command.merge_commmand(command_list,command);
			expect(command_list.length).toEqual(1)
			expect(command_list[0].data["value"]).toEqual("update")
		})

		it("merge_commands",function(){
			command = new Command("update",{"value":"update"},1)
			command_list = [
				new Command("create",{"value": "test"}),
				new Command("update",{"value": "test"},1),
				new Command("update",{"value": "test"},2)
			]

			Command.merge_commmand(command_list,command);
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