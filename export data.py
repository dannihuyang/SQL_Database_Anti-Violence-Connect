import pandas as pd


file_path = '/Users/william/Desktop/24 Summer/CS 5200/output.xlsx' 
df = pd.read_excel(file_path)


sql_data = []


for index, row in df.iterrows():
    sql_data.append(f"({row['incident_id']}, {row['need_id']}, '{row['need_description']}')")


result = ",\n".join(sql_data)
print(result)



print(f"数据已保存 {output_file_path}")
